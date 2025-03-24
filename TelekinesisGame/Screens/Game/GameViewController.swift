//
//  AquariumViewController.swift
//  BBB
//
//  Created by User on 24.01.2025.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import Vision

protocol IGameViewController: UIViewController {
    func goToMenu()
    func showResultScreen(resultType: ResultType, coins: Int)
}

final class GameViewController: UIViewController, CAAnimationDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tutorialView: UIView!
    @IBOutlet private weak var tutorialImageView: UIImageView!
    
    // MARK: - Properties
    
    private var gameSceneProtocol: IBalloonGameScene? = nil
    private var captureSession: AVCaptureSession!
    private var handPoseRequest: VNDetectHumanHandPoseRequest!
    
    private var lastPoint: CGPoint = .zero
    
    var levelIndex: Int
    var gameType: LevelType
    
    private let tutorialImages = [
        UIImage(named: "tutorial1"),
        UIImage(named: "tutorial2"),
        UIImage(named: "tutorial3")
    ]
    
    private var currentImageIndex = 0
    
    // MARK: - Lifecycle
    
    init(levelIndex: Int, gameType: LevelType) {
        self.levelIndex = levelIndex
        self.gameType = gameType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let view = self.view as! SKView? {
            switch gameType {
            case .normal:
                if let scene = SKScene(fileNamed: "BalloonGameScene") as? BalloonGameScene {
                    scene.scaleMode = .aspectFill
                    scene.size = UIScreen.main.bounds.size
                    scene.gameViewController = self
                    scene.currentLevelIndex = levelIndex
                    gameSceneProtocol = scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                view.showsPhysics = false
            case .hard:
                if let scene = SKScene(fileNamed: "BalloonGameScene") as? BalloonGameScene {
                    scene.scaleMode = .aspectFill
                    scene.size = UIScreen.main.bounds.size
                    scene.gameViewController = self
                    scene.currentLevelIndex = levelIndex
                    gameSceneProtocol = scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                view.showsPhysics = false
            }
            
        }
        
        if let firstImage = tutorialImages.first {
            animateImageChange(newImage: firstImage)
        }
        
        tutorialImageView.addTapGesture {
            if self.currentImageIndex < self.tutorialImages.count - 1 {
                self.currentImageIndex += 1
                self.animateImageChange(newImage: self.tutorialImages[self.currentImageIndex])
            } else {
                self.hideTutorialElements()
            }
        }
    }
    
    // MARK: - Private functions
    
    private func animateImageChange(newImage: UIImage?) {
        UIView.transition(with: tutorialImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.tutorialImageView.image = newImage
        })
    }
    
    private func hideTutorialElements() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tutorialView.alpha = 0
        }) { _ in
            self.tutorialView.isHidden = true
            self.gameSceneProtocol?.startGameAfterTutorial()
        }
    }
    
    private func setupCamera() {
        self.handPoseRequest = VNDetectHumanHandPoseRequest()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession = AVCaptureSession()
            self.captureSession.sessionPreset = .high
            
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                // "Ошибка: Камера не найдена"
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if self.captureSession.canAddInput(input) {
                    self.captureSession.addInput(input)
                }
                
                let videoOutput = AVCaptureVideoDataOutput()
                if self.captureSession.canAddOutput(videoOutput) {
                    self.captureSession.addOutput(videoOutput)
                }
                
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                
                self.captureSession.startRunning()
                
            } catch {
                print("Error config camera: \(error)")
            }
        }
    }
    
    private func processHandPose(_ observations: [VNHumanHandPoseObservation]) {
        guard let hand = observations.first else { return }

        do {
            let thumbTip = try hand.recognizedPoint(.thumbTip)
            let indexTip = try hand.recognizedPoint(.indexTip)
            let palm = try hand.recognizedPoint(.wrist)

            let pinchDistance = distanceBetween(thumbTip, indexTip)

            // Рассчитываем координаты в фоновом потоке
            let smoothedX = (self.lastPoint.x * 0.8) + ((1 - palm.location.y) * UIScreen.main.bounds.width * 0.2)
            let smoothedY = (self.lastPoint.y * 0.8) + (palm.location.x * UIScreen.main.bounds.height * 0.2)
            let newPosition = CGPoint(x: smoothedX, y: smoothedY)

            // UI и работу со сценой выполняем в главном потоке
            DispatchQueue.main.async {
                self.lastPoint = newPosition

                if let scene = self.gameSceneProtocol {
                    let convertedPosition = self.view.convert(newPosition, to: scene)
                    if pinchDistance < 0.1 {
                        self.gameSceneProtocol?.updateFingerPosition(to: convertedPosition)
                    }
                }
            }

        } catch {
            print("Error recognizing hand pose: \(error)")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try requestHandler.perform([handPoseRequest])
            if let results = handPoseRequest.results {
                processHandPose(results)
            }
        } catch {
            print("Error processing frame: \(error)")
        }
    }
    
    private func distanceBetween(_ point1: VNRecognizedPoint, _ point2: VNRecognizedPoint) -> CGFloat {
        let dx = point1.location.x - point2.location.x
        let dy = point1.location.y - point2.location.y
        return sqrt(dx * dx + dy * dy)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        if let menuViewController = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            SoundMusicManager.shared.stopPlaying()
            SoundMusicManager.shared.playMenuBackgroundMusic()
            navigationController?.popToViewController(menuViewController, animated: true)
        }
    }
}

extension GameViewController: IGameViewController {
    func goToMenu() { }
    
    func showResultScreen(resultType: ResultType, coins: Int) {
        if let currentViewController = navigationController?.visibleViewController, currentViewController is ResultViewController {
            return
        } else {
            let resultVC = ResultAssembly().assemble(with: resultType, coins: coins)
            navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}
