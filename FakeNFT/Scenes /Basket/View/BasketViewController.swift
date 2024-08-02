import UIKit


final class BasketViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NFTBasketCell.self, forCellReuseIdentifier: NFTBasketCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var barBackgroundView = BarBackgroundView()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .blackDay
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .greenUniversal
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var stubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "Корзина пуста"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        view.addSubview(label)
        label.constraintCenters(to: view)
        view.layer.zPosition = 2
        view.isHidden = true
        return view
    }()
    
    private var nftList: [NFTBasketModel] = [] {
        didSet {
            stubView.isHidden = !nftList.isEmpty
            navigationItem.rightBarButtonItem?.tintColor = nftList.isEmpty ? .white : .blackDay
        }
    }
    
    private let presenter: BasketPresenter
    
    init(presenter: BasketPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    func setup(nftList: [NFTBasketModel], countNft: String, sumNft: String) {
        self.nftList = nftList
        countLabel.text = countNft
        sumLabel.text = sumNft
        tableView.reloadData()
    }
}

private extension BasketViewController {
    
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        activateConstraints()
        setupNavBar()
        addActions()
        presenter.getInfo()
    }
    
    func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort"), style: .done, target: self, action: #selector(Self.sortDidTap))
        self.navigationItem.rightBarButtonItem?.tintColor = .blackDay
        self.navigationItem.backButtonTitle = ""
    }
    
    func addSubviews() {
        [tableView,
        barBackgroundView,
        payButton,
        countLabel,
        sumLabel,
        stubView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: barBackgroundView.topAnchor),
            barBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            barBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            barBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.topAnchor.constraint(equalTo: barBackgroundView.topAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: barBackgroundView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: barBackgroundView.bottomAnchor, constant: -16),
            countLabel.leadingAnchor.constraint(equalTo: barBackgroundView.leadingAnchor, constant: 16),
            countLabel.topAnchor.constraint(equalTo: barBackgroundView.topAnchor, constant: 16),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: payButton.leadingAnchor, constant: -24),
            sumLabel.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            sumLabel.bottomAnchor.constraint(equalTo: barBackgroundView.bottomAnchor, constant: -16),
            sumLabel.topAnchor.constraint(greaterThanOrEqualTo: countLabel.bottomAnchor),
            sumLabel.trailingAnchor.constraint(lessThanOrEqualTo: payButton.leadingAnchor, constant: -24)
        ])
        stubView.constraintEdges(to: view)
    }
    
    func addActions() {
        payButton.addTarget(self, action: #selector(Self.payDidTap), for: .touchUpInside)
    }
    
    @objc
    func sortDidTap() {
        
    }
    
    @objc
    func payDidTap() {
        showPaymentViewController()
    }
    
    func showDeleteController(id: String) {
        guard let nft = nftList.first(where: { $0.id == id }) else { return }
        
        let deleteViewController = DeleteNFTViewController(nft: nft)
        deleteViewController.modalPresentationStyle = .overCurrentContext
        deleteViewController.modalTransitionStyle = .crossDissolve
        deleteViewController.deleteAction = { [weak self] id in
            self?.presenter.removeNftBy(id: id)
        }
        present(deleteViewController, animated: true)
    }
    
    func showPaymentViewController() {
        let paymentViewController = PaymentViewController()
        paymentViewController.modalPresentationStyle = .overCurrentContext
        paymentViewController.modalTransitionStyle = .crossDissolve
        paymentViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(paymentViewController, animated: true)
    }
}

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nftList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTBasketCell.reuseIdentifier, for: indexPath) as? NFTBasketCell 
        else { return UITableViewCell() }
        
        cell.setup(nft: nftList[indexPath.row], deleteNftAction: { [weak self] id in
            self?.showDeleteController(id: id)
        })
        return cell
    }
}

extension BasketViewController: UITableViewDelegate {
    
}
