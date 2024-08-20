import UIKit


final class SuccessViewController: UIViewController {
    
    private lazy var imageView = UIImageView(image: UIImage(named: "success"))
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Вернуться в каталог", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 152),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 278),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ])
        
        button.addTarget(self, action: #selector(Self.dismissDidTap), for: .touchUpInside)
        
        navigationItem.hidesBackButton = true
    }
    
    @objc
    private func dismissDidTap() {
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
        if let tabBarController = UIApplication.shared.windows.first?.rootViewController
 as? TabBarController {
            tabBarController.selectedIndex = 0
        }
    }
}
