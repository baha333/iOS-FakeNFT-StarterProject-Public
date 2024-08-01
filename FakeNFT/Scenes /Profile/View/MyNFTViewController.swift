import UIKit

protocol MyNFTLikesDelegate: AnyObject {
    func didUpdateLikedNFTCount(count: Int)
}

protocol MyNFTViewControllerProtocol: AnyObject {
    var presenter: MyNFTPresenter? { get set }
    func updateMyNFTs(nfts: [NFT]?)
}

final class MyNFTViewController: UIViewController {
    //MARK:  - Public Properties
    var presenter: MyNFTPresenter?
    
    //MARK:  - Private Properties
    private var nftID: [String]
    private var likedNFT: [String]
    private let profileService = ProfileService.shared
    private let editProfileService = EditProfileService.shared
    
    private lazy var returnButton: UIBarButtonItem = {
        let button = UIBarButtonItem( image: UIImage(systemName: "chevron.left"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(returnButtonTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()
    
    private lazy var myNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MyNFTCell.self,
            forCellReuseIdentifier: MyNFTCell.cellID
        )
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Initializers
    init(nftID: [String], likedID: [String]) {
        self.nftID = nftID
        self.likedNFT = likedID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    @objc func returnButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
      
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingNavigation()
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
        
        presenter = MyNFTPresenter(nftID: self.nftID, likedNFT: self.likedNFT, editProfileService: editProfileService)
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    //MARK: - Private Methods

    private func customizingNavigation() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "ypWhite")
        navigationItem.title = "Мой NFT"
        navigationItem.leftBarButtonItem = returnButton
    }
    
    private func customizingScreenElements() {
        view.addSubview(myNFTTableView)
    }
    
    private func customizingTheLayoutOfScreenElements() {
        NSLayoutConstraint.activate([
            myNFTTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            myNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            myNFTTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let presenter = presenter {
            if presenter.nfts.isEmpty {
                myNFTTableView.isHidden = true
                navigationItem.title = ""
            } else {
                myNFTTableView.isHidden = false
                navigationItem.title = "Мой NFT"
            }
        } else {
            print("presenter is nil")
        }
        return presenter?.nfts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.cellID,for: indexPath) as? MyNFTCell else {fatalError("Could not cast to MyNFTCell")}
        
        guard let nft = presenter?.nfts[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.changingNFT(nft: nft)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - MyNFTViewControllerProtocol
extension MyNFTViewController: MyNFTViewControllerProtocol {
    func updateMyNFTs(nfts: [NFT]?) {
        guard let presenter = presenter else {
            print("Presenter is nil")
            return
        }
        
        guard let nfts = nfts else {
            print("Received nil NFTs")
            return
        }
        
        presenter.nfts = nfts
        print ("МОИ НФТ = \(presenter.nfts)")
        
        DispatchQueue.main.async {
            self.myNFTTableView.reloadData()
        }
    }
}

