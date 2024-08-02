import UIKit

final class DeleteNFTViewController: UIViewController {
    
    var deleteAction: ((String) -> Void)?
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .blackDay
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.redUniversal, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.setTitle("Вернуться", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [deleteButton, cancelButton])
        stack.spacing = 8
        return stack
    }()
    
    private let nft: NFTBasketModel
    
    init(nft: NFTBasketModel) {
        self.nft = nft
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
}

private extension DeleteNFTViewController {
    
    func setupController() {
        imageView.kf.setImage(with: nft.imageUrl)
        
        addSubviews()
        activateConstraints()
        addActions()
    }
    
    func addSubviews() {
        [visualEffectView,
        imageView,
        label,
        buttonStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -12),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -36),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 36),
            label.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -20),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            cancelButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 1),
            buttonStack.heightAnchor.constraint(equalToConstant: 44),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.topAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor, constant: 41),
            label.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor, constant: -41)
        ])
    }
    
    func addActions() {
        deleteButton.addTarget(self, action: #selector(Self.didTapDeleteButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(Self.didTapCancelButton), for: .touchUpInside)
    }
    
    @objc
    func didTapDeleteButton() {
        deleteAction?(nft.id)
        dismiss(animated: true)
    }
    
    @objc
    func didTapCancelButton() {
        dismiss(animated: true)
    }
}
