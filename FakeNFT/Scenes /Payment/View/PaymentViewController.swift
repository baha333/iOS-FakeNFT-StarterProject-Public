import UIKit


final class PaymentViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(CurrencyViewCell.self, forCellWithReuseIdentifier: CurrencyViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private lazy var barBackgroundView = BarBackgroundView()
    
    private lazy var payButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Оплатить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .blackDay
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var link: UIButton = {
        let button = UIButton()
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.setTitleColor(.blueUniversal, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        return button
    }()
    
    private var currencies: [CurrencyModel] = [
        CurrencyModel(
            id: "123",
            name: "123",
            title: "123",
            image: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st%3D1722606933~exp%3D1722610533~hmac%3Db3d59a60686619eb9b186e51f382bb81fe40311368904a0181faae43bc1f5e1d&w=1060"
        ),
        CurrencyModel(
            id: "123",
            name: "123",
            title: "123",
            image: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st%3D1722606933~exp%3D1722610533~hmac%3Db3d59a60686619eb9b186e51f382bb81fe40311368904a0181faae43bc1f5e1d&w=1060"
        ),
        CurrencyModel(
            id: "123",
            name: "123",
            title: "123",
            image: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st%3D1722606933~exp%3D1722610533~hmac%3Db3d59a60686619eb9b186e51f382bb81fe40311368904a0181faae43bc1f5e1d&w=1060"
        ),
        CurrencyModel(
            id: "123",
            name: "123",
            title: "123",
            image: "https://img.freepik.com/free-photo/adorable-illustration-kittens-playing-forest-generative-ai_260559-483.jpg?t=st%3D1722606933~exp%3D1722610533~hmac%3Db3d59a60686619eb9b186e51f382bb81fe40311368904a0181faae43bc1f5e1d&w=1060"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

private extension PaymentViewController {
    
    func setupViewController() {        
        addSubviews()
        activateConstraints()
        setupNavBar()
        addActions()
    }
    
    func addSubviews() {
        [collectionView,
        barBackgroundView,
        payButton,
        label,
        link].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: barBackgroundView.topAnchor),
            barBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            barBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            barBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackgroundView.heightAnchor.constraint(equalToConstant: 186),
            payButton.bottomAnchor.constraint(equalTo: barBackgroundView.bottomAnchor, constant: -50),
            payButton.leadingAnchor.constraint(equalTo: barBackgroundView.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: barBackgroundView.trailingAnchor, constant: -12),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            label.topAnchor.constraint(equalTo: barBackgroundView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: barBackgroundView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: barBackgroundView.trailingAnchor, constant: -16),
            link.topAnchor.constraint(equalTo: label.bottomAnchor),
            link.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            link.trailingAnchor.constraint(lessThanOrEqualTo: label.trailingAnchor),
            link.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16)
        ])
    }
    
    func setupNavBar() {
        navigationItem.title = "Выберите способ оплаты"
    }
    
    func addActions() {
        link.addTarget(self, action: #selector(Self.linkDidTap), for: .touchUpInside)
        payButton.addTarget(self, action: #selector(Self.payDidTap), for: .touchUpInside)
    }
    
    @objc
    func linkDidTap() {
        present(WebViewViewController(), animated: true)
    }
    
    @objc
    func payDidTap() {
        navigationController?.pushViewController(SuccessViewController(), animated: true)
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            return CGSize(width: (collectionView.bounds.width - 7) / 2.0, height: 46)
        }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 7
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyViewCell.reuseIdentifier, for: indexPath) as? CurrencyViewCell 
        else {
            return UICollectionViewCell()
        }
        
        cell.setup(currency: currencies[indexPath.row])
        
        return cell
    }
}
