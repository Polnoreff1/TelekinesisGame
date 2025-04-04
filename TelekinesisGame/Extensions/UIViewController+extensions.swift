import UIKit

extension UIViewController {
    func showAllert(title: String, message: String, titleConfirmAction: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let confirmAction = UIAlertAction(
            title: titleConfirmAction,
            style: UIAlertAction.Style.default
        ) { (action) in
            completion?()
            return
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
}
