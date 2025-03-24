//
//  LooseNode.swift
//  BL
//
//  Created by User on 07.03.2025.
//

import Foundation
import SpriteKit

class LooseNode: SKSpriteNode {
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.looseNode
        self.physicsBody?.contactTestBitMask = PhysicsBodies.balloon
        self.physicsBody?.collisionBitMask = PhysicsBodies.balloon
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

