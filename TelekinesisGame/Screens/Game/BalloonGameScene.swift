import SpriteKit

protocol IBallGameScene: SKScene {
    func updateFingerPosition(to position: CGPoint)
    func startGameAfterTutorial()
}

final class BallGameScene: SKScene {
    
    weak var gameViewController: IGameViewController?
    var currentLevelIndex: Int = 0
    
    private lazy var cameraNode = SKCameraNode()
    
    private var isAddedBalloon: Bool = false
    private var isCanStart: Bool = false
    
    lazy var balloon: BalloonNode = {
        let balloon: BalloonNode = BalloonNode(textureName: "ball")
        if let startNode = children.first(where: { $0.name == "BallStartNodde" }) {
            balloon.position = CGPoint(x: startNode.frame.midX, y: startNode.frame.midY)
        }
        
        return balloon
    }()
    
    private func setUpScene() {
        setupCamera()
        setupGameNodes()
        setupGame()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.5)
    }
    
    private func setupGame() {
        startGame()
    }
    
    private func startGame() {
        isCanStart = true
    }
    
    private func setupCamera() {
        cameraNode.zPosition = 10
        cameraNode.run(.scale(by: 1.8, duration: 0.2))
        addChild(cameraNode)
        
        camera = cameraNode
    }
    
    private func setupGameNodes() {
        
        children.forEach { child in
            switch child.name {
            case "Spikes":
                if let spikes = child as? Spikes {
                    spikes.setupPhysics()
                }
            case "FinishNode":
                if let finishNode = child as? FinishNode {
                    finishNode.setupPhysics()
                }
                break
            case "Border":
                if let border = child as? Border {
                    border.setupPhysics()
                }
            default:
                break
            }
        }
    }
    
    private func addBall() {
        self.run(.sequence([
            .wait(forDuration: 1),
            .run {
                self.addChild(self.balloon)
            }
        ]))
    }
    
    private func clearScene() {
        removeAllActions()
        self.run(.wait(forDuration: 0.3)) {
            self.removeAllChildren()
            self.removeFromParent()
        }
    }
    
    private func showResultVC(resultType: ResultType) {
        clearScene()
        if resultType == .win {
            LevelManager.shared.money += (self.currentLevelIndex * 100)
            UserDefaults.standard.set(true, forKey: "is\(self.currentLevelIndex)GameLevelCompleted")
        }
        
        gameViewController?.showResultScreen(resultType: resultType, coins: self.currentLevelIndex * 100)
    }
}

extension BallGameScene: SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        self.setUpScene()
        self.physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        if balloon.parent != nil {
            self.cameraNode.run(.moveTo(y: balloon.position.y, duration: 0.2))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody, secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.balloon,
            rhs: secondBody.categoryBitMask & PhysicsBodies.spikes
        ) {
            showResultVC(resultType: .loss)
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.balloon,
            rhs: secondBody.categoryBitMask & PhysicsBodies.finishNode
        ) {
            showResultVC(resultType: .win)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody, secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
    }
}

extension BallGameScene: IBallGameScene {
    func updateFingerPosition(to position: CGPoint) {
        guard isCanStart else { return }
        
        if !isAddedBalloon {
            addBall()
            isAddedBalloon = true
        }
        
        let currentPosition = balloon.position
        
        let dx = position.x - currentPosition.x
        let dy = position.y - currentPosition.y
        
        let distance = sqrt(dx * dx + dy * dy)
        guard distance > 0 else { return }
        
        let impulseStrength: CGFloat = 2.0
        let impulse = CGVector(dx: (dx / distance) * impulseStrength,
                               dy: (dy / distance) * impulseStrength)
        
        balloon.physicsBody?.applyImpulse(impulse)
        
        let maxSpeed: CGFloat = 300.0
        if let velocity = balloon.physicsBody?.velocity {
            let speed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
            if speed > maxSpeed {
                let scale = maxSpeed / speed
                balloon.physicsBody?.velocity = CGVector(dx: velocity.dx * scale, dy: velocity.dy * scale)
            }
        }
    }
    
    func startGameAfterTutorial() {
        startGame()
    }
}
