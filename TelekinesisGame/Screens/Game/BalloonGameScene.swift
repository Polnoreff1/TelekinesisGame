import SpriteKit

protocol IBalloonGameScene: SKScene {
    func updateFingerPosition(to position: CGPoint)
    func startGameAfterTutorial()
}

final class BalloonGameScene: SKScene {
    
    weak var gameViewController: IGameViewController?
    var currentLevelIndex: Int = 0
    // private var magicStickNode: PlayerSword = PlayerSword()
    
    private lazy var cameraNode = SKCameraNode()
    
    var isAddedBalloon: Bool = false
    var isCanLoose: Bool {
        if LevelManager.shared.ammo > 1 {
            LevelManager.shared.ammo -= 1
            return false
        } else {
            return true
        }
    }
    
    var isCanStart: Bool = false
    
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
        //        self.startGame()
    }
    
    private func startGame() {
        isCanStart = true
        
        self.children.forEach { child in
            if let gameBG = child as? SKSpriteNode {
                if gameBG.name == "gameBG" {
                    //                    gameBG.size = UIScreen.main.bounds.size
                }
            }
        }
    }
    
    private func setupCamera() {
        cameraNode.zPosition = 10
        cameraNode.run(.scale(by: 1.8, duration: 0.2))
        addChild(cameraNode)
//        self.addChild(ingredient1Button)
//        
//        
//        ingredient1Button.zPosition = 905
        
        
        camera = cameraNode
    }
    
    func setupGameNodes() {
        
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
            case "MakeBiggerNode":
                if let cgn = child as? MakeBiggerNode {
                    cgn.setupPhysics()
                }
            case "MakeSmallerNode":
                if let cgn = child as? MakeSmallerNode {
                    cgn.setupPhysics()
                }
            case "LooseNode":
                if let cgn = child as? LooseNode {
                    cgn.setupPhysics()
                }
            default:
                break
            }
        }
    }
    
    func useShield() {
        
    }
    
    func shakeScreen() {
        if let gameBG = self.childNode(withName: "gameBG") as? SKSpriteNode {
            let shakeDuration: Double = 0.05
            let shakeAmount: CGFloat = 10
            
            let shakeLeft = SKAction.moveBy(x: -shakeAmount, y: 0, duration: shakeDuration)
            let shakeRight = SKAction.moveBy(x: shakeAmount, y: 0, duration: shakeDuration)
            let shakeUp = SKAction.moveBy(x: 0, y: shakeAmount, duration: shakeDuration)
            let shakeDown = SKAction.moveBy(x: 0, y: -shakeAmount, duration: shakeDuration)
            
            let shakeSequence = SKAction.sequence([shakeLeft, shakeRight, shakeUp, shakeDown])
            let resetPosition = SKAction.moveBy(x: frame.midX, y: frame.midY, duration: shakeDuration)
            gameBG.run(SKAction.sequence([shakeSequence, resetPosition]))
        }
    }
    
    func updateCameraPosition(for playerNode: SKNode) {
        if let element = children.first(where: { $0.name == "gameBG" }) {
            let initialGamePlaceHeight = element.frame.height
            let totalHeight = initialGamePlaceHeight * 4
            let playerY = playerNode.position.y
            var topInset: CGFloat = 0
            if let window = UIApplication.shared.windows.first {
                topInset = window.safeAreaInsets.top
            }
            var maxY = totalHeight - element.frame.height
            if topInset > 0 {
                maxY = maxY - topInset + 50
            }
            let minY = cameraNode.frame.height / 2
            let y = clamp(playerY + 150, minY, maxY)
            self.cameraNode.run(.moveTo(y: y, duration: 0.2))
        }
    }
    
    func clamp<T: Comparable>(_ value: T, _ lower: T, _ upper: T) -> T {
        return min(max(value, lower), upper)
    }
    
    func addParticlesToFight(for point: CGPoint) {
        if let sparks = SKEmitterNode(fileNamed: "Sparks.sks") {
            sparks.position = point
            sparks.zPosition = 1000
            self.addChild(sparks)
            
            let wait = SKAction.wait(forDuration: 0.5)
            let remove = SKAction.removeFromParent()
            sparks.run(SKAction.sequence([wait, remove]))
        }
    }
    
    func addDifficulty() {
        self.run(.repeatForever(.sequence([
            .wait(forDuration: TimeInterval(Double.random(in: 5...10))),
            .run {
                var arrAct:[SKAction] = []
                let countBombs = Int.random(in: 1 ... 3)
                for i in 1 ... countBombs {
                    let bomb = FlyingSpikes()
                    
                    bomb.position.x = Bool.random() ? -self.frame.width/2 + bomb.frame.width/2 : self.frame.width/2 - bomb.frame.width/2
                    bomb.position.y = CGFloat.random(in: 0 ... self.frame.height/2)
                    
                    bomb.physicsBody?.affectedByGravity = true
                    bomb.physicsBody?.isDynamic = true
                    let dxImpulse: CGFloat = CGFloat.random(in: 50 ... 70)
                    let impulse = CGVector(dx: bomb.position.x > 0 ? -dxImpulse : dxImpulse, dy: CGFloat.random(in: 15 ... 40))
                    
                    let alertNode = SKSpriteNode(texture: SKTexture(imageNamed: "alertNode"), color: .clear, size: CGSize(width: bomb.frame.height, height: bomb.frame.height))
                    alertNode.zPosition = self.cameraNode.zPosition + 200
                    alertNode.position = bomb.position
                    self.cameraNode.addChild(alertNode)
                    arrAct.append(.run {
                        alertNode.run(.wait(forDuration: 1)) {
                            self.cameraNode.addChild(bomb)
                            bomb.physicsBody?.applyImpulse(impulse)
                            alertNode.removeFromParent()
                        }
                    })
                    
                    arrAct.append(.wait(forDuration: 0.5))
                }
                self.run(.sequence(arrAct))
            }
        ])))
    }
    
    // MARK: Fights end -
    
    
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

extension BalloonGameScene: SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        self.setUpScene()
        self.physicsWorld.contactDelegate = self
        SoundMusicManager.shared.stopPlaying()
        SoundMusicManager.shared.playGameMusic()
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
            rhs: secondBody.categoryBitMask & PhysicsBodies.finishNode
        ) {
            // победа
            showResultVC(resultType: .win)
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.balloon,
            rhs: secondBody.categoryBitMask & PhysicsBodies.makeBiggerNode
        ) {
            secondBody.node?.removeFromParent()
            let newSize: CGSize = CGSize(width: balloon.size.width + 50, height: balloon.size.height + 50)
            balloon.correctUpdateSize(newSize: newSize)
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.balloon,
            rhs: secondBody.categoryBitMask & PhysicsBodies.makeSmallerNode
        ) {
            secondBody.node?.removeFromParent()
            let newSize: CGSize = CGSize(width: balloon.size.width - 50, height: balloon.size.height - 50)
            balloon.correctUpdateSize(newSize: newSize)
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.balloon,
            rhs: secondBody.categoryBitMask & PhysicsBodies.spikes
        ) {
            print(LevelManager.shared.ammo)
            if isCanLoose {
                showResultVC(resultType: .loss)
            } else {
                if let balloon = firstBody.node {
                    let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.25)
                    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
                    let sequence = SKAction.sequence([fadeOut, fadeIn, fadeOut, fadeIn])
                    balloon.run(sequence)
                }
                
                if let spike = secondBody.node {
                    spike.physicsBody = nil
                    let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.25)
                    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
                    let removeAction = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([fadeOut, fadeIn, fadeOut, fadeIn, removeAction])
                    spike.run(sequence)
                }
            }
        }
        
        if .touched(
            lhs: firstBody.categoryBitMask & PhysicsBodies.balloon,
            rhs: secondBody.categoryBitMask & PhysicsBodies.looseNode
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
        
        //        if .touched(
        //            lhs: firstBody.categoryBitMask & PhysicsBodies.playerSword,
        //            rhs: secondBody.categoryBitMask & PhysicsBodies.ingredientPh
        //        ) {
        //            if secondBody.node is IngredientNode {
        //                if isCanContinueCutting == false {
        //                    self.cutIngredient()
        //                    isCanContinueCutting = true
        //                }
        //            }
        //        }
    }
}

extension BalloonGameScene: IBalloonGameScene {
    func updateFingerPosition(to position: CGPoint) {
        guard isCanStart else { return }
        
        if !isAddedBalloon {
            addBall()
            isAddedBalloon = true
        }
        
        // Получаем текущую позицию мяча
        let currentPosition = balloon.position
        
        // Рассчитываем направление импульса
        let dx = position.x - currentPosition.x
        let dy = position.y - currentPosition.y
        
        // Нормализация вектора
        let distance = sqrt(dx * dx + dy * dy)
        guard distance > 0 else { return }
        
        // Контролируем силу импульса (чтобы не улетал)
        let impulseStrength: CGFloat = 2.0 // Чем больше, тем сильнее толчок
        let impulse = CGVector(dx: (dx / distance) * impulseStrength,
                               dy: (dy / distance) * impulseStrength)
        
        // Применяем импульс к физическому телу мяча
        balloon.physicsBody?.applyImpulse(impulse)
        
        // Ограничиваем максимальную скорость для плавности
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
