import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: "Корзина",
        image: UIImage(named: "basket"),
        tag: 1
    )

    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "profileBar"),
        tag: 2
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        catalogController.hidesBottomBarWhenPushed = false
        
        let basketPresenter = BasketPresenter()
        let basketController = BasketViewController(presenter: basketPresenter)
        basketPresenter.viewController = basketController
        let basketNavController = UINavigationController(rootViewController: basketController)
        basketNavController.navigationBar.tintColor = .blackDay
        basketController.tabBarItem = basketTabBarItem

        let profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileViewController.tabBarItem = profileTabBarItem
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        viewControllers = [catalogController, basketNavController, profileNavigationController]


        view.backgroundColor = .systemBackground
    }
}
