import UIKit
import ProgressHUD


extension UIViewController {
    func showIsLoading(_ isLoading: Bool) {
        if isLoading {
            ProgressHUD.show()
        } else {
            ProgressHUD.dismiss()
        }
    }
}

extension UIViewController {
    func showErrorAlert(title: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in
            completion?()
        }))
        present(alertController, animated: true)
    }
}
