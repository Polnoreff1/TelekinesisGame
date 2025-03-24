import Foundation
import SpriteKit

class MakeSmallerNode: SKSpriteNode {
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.makeSmallerNode
        self.physicsBody?.contactTestBitMask = PhysicsBodies.balloon
        self.physicsBody?.collisionBitMask = 0
        self.run(.repeatForever(.sequence([
            .moveTo(y: self.position.y + 12, duration: 1),
            .moveTo(y: self.position.y, duration: 1)
        ])))
    }
}
