//
//  FlyingSpikes.swift
//  Casumo1
//
//  Created by 1234 on 04.07.2023.
//

import SpriteKit

final class FlyingSpikes: SKSpriteNode {
    init() {
        let size = CGSize(width: 50, height: 50)
        let texture = SKTexture(imageNamed: "bladeSpikes")
        super.init(texture: texture, color: .red, size: size)
        self.zPosition = ZPositions.cameraElements + 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsBodies.spikes
        self.physicsBody?.contactTestBitMask = PhysicsBodies.balloon
        self.physicsBody?.collisionBitMask = 0
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 1)
        let repeatAction = SKAction.repeatForever(rotateAction)
        self.run(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
