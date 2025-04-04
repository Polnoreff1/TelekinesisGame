import Foundation
import UIKit

extension Bool {
    static func touched(lhs: UInt32, rhs: UInt32) -> Bool {
        lhs != 0 && rhs != 0
    }
}

extension Double {
    func formatAsPercentage() -> String {
        let percentage = self * 100
        let formattedString = String(format: "%.0f%%", percentage)
        return formattedString
    }
}

private var tapGestureKey: UInt8 = 0

extension UIView {
    func addTapGesture(completion: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        
        if let completion = completion {
            objc_setAssociatedObject(self, &tapGestureKey, completion, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture() {
        if let completion = objc_getAssociatedObject(self, &tapGestureKey) as? (() -> Void) {
            completion()
        }
    }
}


public func shakeButton(button: UIButton) {
    let shake = CABasicAnimation(keyPath: "position")
    shake.duration = 0.1
    shake.repeatCount = 2
    shake.autoreverses = true
    
    let fromPoint = CGPoint(x: button.center.x - 5, y: button.center.y)
    let toPoint = CGPoint(x: button.center.x + 5, y: button.center.y)
    shake.fromValue = NSValue(cgPoint: fromPoint)
    shake.toValue = NSValue(cgPoint: toPoint)
    button.layer.add(shake, forKey: "position")
}
