import SpriteKit

class BalloonNode: SKSpriteNode {
    
    init(textureName: String) {
        let size = CGSize(width: 100, height: 100)
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .clear, size: size)
        self.zPosition = ZPositions.ui + 1000
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = PhysicsBodies.balloon
        self.physicsBody?.contactTestBitMask = PhysicsBodies.playerHand | PhysicsBodies.makeSmallerNode | PhysicsBodies.makeBiggerNode | PhysicsBodies.spikes | PhysicsBodies.finishNode | PhysicsBodies.looseNode
        self.physicsBody?.collisionBitMask = PhysicsBodies.playerHand | PhysicsBodies.border
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.restitution = 0.8
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.mass = 0.1
    }
    
    func correctUpdateSize(newSize: CGSize) {
        self.size = newSize
        self.physicsBody = SKPhysicsBody(circleOfRadius: newSize.width / 2)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = PhysicsBodies.balloon
        self.physicsBody?.contactTestBitMask = PhysicsBodies.playerHand | PhysicsBodies.makeSmallerNode | PhysicsBodies.makeBiggerNode | PhysicsBodies.spikes | PhysicsBodies.finishNode | PhysicsBodies.looseNode
        self.physicsBody?.collisionBitMask = PhysicsBodies.playerHand | PhysicsBodies.border
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.restitution = 0.8
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.mass = 0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


