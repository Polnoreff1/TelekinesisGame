import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import Vision
import AHandGestureKit

protocol IGameViewController: UIViewController {
    func goToMenu()
    func showResultScreen(resultType: ResultType, coins: Int)
}

final class GameViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Properties
    
    private var gameSceneProtocol: IBallGameScene? = nil
    private var captureSession: AVCaptureSession!
    private var handPoseRequest: VNDetectHumanHandPoseRequest!
    
    private var handGestureKit: HandGestureKit?
    
    private var lastPoint: CGPoint = .zero
    
    var levelIndex: Int
        
    // MARK: - Lifecycle
    
    init(levelIndex: Int) {
        self.levelIndex = levelIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handGestureKit?.stopGestureRecognition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "BallGameScene") as? BallGameScene {
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
        
        handGestureKit = HandGestureKit()
        
        Task {
            do {
                try await handGestureKit?.startGestureRecognition(
                    in: self.view,
                    targetGestures: [.pinch]
                ) { [weak self] gesture, point in
                    guard let self = self,
                          let point = point,
                          let gesture = gesture else { return }
                    
                    DispatchQueue.main.async {
                        if let scene = self.gameSceneProtocol {
                            let convertedPosition = self.view.convert(point, to: scene)
                            self.gameSceneProtocol?.updateFingerPosition(to: convertedPosition)
                        }
                    }
                }
            } catch {
                print("Ошибка при запуске распознавания жестов: \(error)")
            }
        }
    }
    
    // MARK: - Private functions
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        if let menuViewController = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
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
