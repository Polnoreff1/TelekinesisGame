import SpriteKit

extension SKSpriteNode {
    func setScaleByHeight(texture: SKTexture, newHeight: CGFloat) {
        let newScale = self.xScale * newHeight/self.frame.height
        self.setScale(newScale)
    }
    
    func moveToPoint(to targetPoint: CGPoint) {
        let startPosition: CGPoint = self.position
        self.run(.repeatForever(.sequence([
            .move(to: targetPoint, duration: 1.5),
            .move(to: startPosition, duration: 1.5)
        ])))
    }
    
    func moveToPointBySpeed(speed: CGFloat, targetPoint: CGPoint, actionName: String = "moveToPointWithSpeedAction", completion: @escaping () -> ()) {
        let distance = sqrt(pow(self.position.x - targetPoint.x, 2) + pow(self.position.y - targetPoint.y, 2))
        let duration = abs(distance * 1/(100 * speed))
        print("actionData:distance",distance)
        print("actionData:duration",duration)
        print("actionData:actionName", actionName)
        let action = SKAction.sequence([
            .move(to: targetPoint, duration: duration),
            .run {
                completion()
            }
        ])
        print("actionName", actionName)
        self.run(action, withKey: actionName)
    }
    
    func shake(count: Int, completion: @escaping () -> ()) {
        var arrActions:[SKAction] = []
        for _ in 0...count - 1 {
            let isUp = Bool.random()
            if (isUp) {
                let distance: CGFloat = Bool.random() ? 2 : -2
                arrActions.append(.moveBy(x: 0, y: distance, duration: 0.1))
                arrActions.append(.moveBy(x: 0, y: -distance, duration: 0.1))
            } else {
                let distance: CGFloat = Bool.random() ? 2 : -2
                arrActions.append(.moveBy(x: distance, y: 0, duration: 0.1))
                arrActions.append(.moveBy(x: -distance, y: 0, duration: 0.1))
            }
        }
        arrActions.append(.run {
            completion()
        })
        self.run(.sequence(arrActions))
    }
    
    func changeTextureWithFadeOut(newTexture: SKTexture, newWidth: CGFloat) {
        self.run(.fadeOut(withDuration: 0.2)) {
            self.texture = newTexture
            self.size = self.getSizeByWidth(texture: newTexture, width: newWidth)
            self.run(.fadeIn(withDuration: 0.2))
        }
    }
    
    func getSizeByWidth(texture: SKTexture, width: CGFloat) -> CGSize {
        let ratio = width/texture.size().width
        let size = CGSize(width: width, height: texture.size().height * ratio)
        return size
    }
    
}

extension SKLabelNode {
    func startTimer(duration: Int, completion: @escaping () -> ()) {
        var arrAct:[SKAction] = []
        for i in 0...duration - 1 {
            let minutes = Int((duration - i)/60)
            let seconds = (duration - i) % 60
            arrAct.append(.run({
                if minutes == 0 {
                    self.text = "\(seconds)s"
                } else {
                    self.text = "\(minutes)m \(seconds)s"
                }
                
            }))
            arrAct.append(.wait(forDuration: 1))
        }
        arrAct.append(.run {
            self.text = "0m 0s"
            completion()
        })
        self.run(.sequence(arrAct))
    }
    
    func changeTextWithFadeOut(newText: String) {
        self.run(.fadeOut(withDuration: 0.3)) {
            self.text = newText
            self.run(.fadeIn(withDuration: 0.3))
        }
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = point.x - x
        return abs(dx)
    }
}

func getSizeByHeight(texture: SKTexture, height: CGFloat) -> CGSize {
    let ratio = height/texture.size().height
    let size = CGSize(width: texture.size().width * ratio, height: height)
    return size
}
