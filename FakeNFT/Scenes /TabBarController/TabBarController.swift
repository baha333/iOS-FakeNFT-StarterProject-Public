import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "profileBar"),
        tag: 0
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: "Корзина",
        image: UIImage(named: "basket"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

<<<<<<< .merge_file_LpskS6
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let basketPresenter = BasketPresenter()
        let basketController = BasketViewController(presenter: basketPresenter)
        basketPresenter.viewController = basketController
        let basketNavController = UINavigationController(rootViewController: basketController)
        basketNavController.navigationBar.tintColor = .blackDay
        basketController.tabBarItem = basketTabBarItem

        viewControllers = [catalogController, basketNavController]
=======
        let profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileViewController.tabBarItem = profileTabBarItem

        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        viewControllers = [profileNavigationController]
>>>>>>> .merge_file_THM34o

        view.backgroundColor = .systemBackground
    }
}
