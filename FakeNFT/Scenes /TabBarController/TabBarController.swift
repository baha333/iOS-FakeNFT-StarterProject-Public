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

    override func viewDidLoad() {
        super.viewDidLoad()

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

        view.backgroundColor = .systemBackground
    }
}
