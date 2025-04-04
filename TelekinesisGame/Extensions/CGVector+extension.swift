import Foundation

extension CGVector {
    func normalized() -> CGVector {
        let length = sqrt(dx*dx + dy*dy)
        return CGVector(dx: dx/length, dy: dy/length)
    }
}

