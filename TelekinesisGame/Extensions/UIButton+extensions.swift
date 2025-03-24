import UIKit

extension UIButton {
    func vibrateSoftly() {
        if SoundMusicManager.shared.isAllowedVibration {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
    }
}

protocol NibRepresentable {
    static var identifier: String { get }
}

extension UIView: NibRepresentable {
    class var identifier: String {
        return String(describing: self)
    }
}
