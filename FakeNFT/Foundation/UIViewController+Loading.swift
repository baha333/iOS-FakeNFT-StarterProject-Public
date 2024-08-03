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
