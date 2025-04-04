import Foundation
import SpriteKit

class Border: SKSpriteNode {
    func setupPhysics(isLower: Bool = false) {
        if isLower {
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height - 600))
        } else {
            self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        }
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.border
        self.physicsBody?.contactTestBitMask = PhysicsBodies.balloon
        self.physicsBody?.collisionBitMask = PhysicsBodies.balloon
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
