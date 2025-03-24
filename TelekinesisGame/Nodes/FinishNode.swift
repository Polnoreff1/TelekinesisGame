//
//  FinishNode.swift
//  ClimbUpGame
//
//  Created by 1234 on 26.06.2023.
//

import Foundation
import SpriteKit

class FinishNode: SKSpriteNode {
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.finishNode
        self.physicsBody?.contactTestBitMask = PhysicsBodies.balloon
        self.physicsBody?.collisionBitMask = 0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
