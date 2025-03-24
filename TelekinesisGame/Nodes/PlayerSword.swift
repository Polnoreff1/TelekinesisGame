import SpriteKit

class PlayerSword: SKSpriteNode {
    init() {
        let size = CGSize(width: 150, height: 150)
        let textureName: String = "defaultSword"
        
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .red, size: size)
        self.zPosition = ZPositions.ui + 999
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: size.height - 75))
        
//        let radius: CGFloat = size.width / 2 * 0.8  // Уменьшаем радиус на 20%
//        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.playerHand
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = PhysicsBodies.balloon
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.mass = 1.1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
