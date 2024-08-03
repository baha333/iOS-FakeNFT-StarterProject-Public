import Foundation
import ProgressHUD

final class BasketPresenter {
    
    weak var viewController: BasketViewController?
    private let nftService: NftService
    private var basketSortStorage: BasketSortStorage
    
    init(nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl()),
         basketSortStorage: BasketSortStorage = BasketSortStorage()
    ) {
        self.nftService = nftService
        self.basketSortStorage = basketSortStorage
    }
    
    private var basket: BasketModel? = nil {
        didSet {
            getNfts()
        }
    }
    
    private var nftList: [BasketNFTModelResponse] = []
    
    private func configViewController() {
        let countNFT = "\(nftList.count) NFT"
        let sumNFT = nftList.reduce(0, { sum, item in
            sum + item.price
        })
        let sumNFTString = String(format: "%.2f", sumNFT) + " ETH"
        var nfts = nftList.compactMap {
            castResponseToModel(nft: $0)
        }
        
        switch basketSortStorage.basketSortType {
        case .price:
            nfts.sort(by: { $0.price < $1.price })
        case .rating:
            nfts.sort(by: { $0.rating < $1.rating })
        case .name:
            nfts.sort(by: { $0.name < $1.name })
        }
        
        viewController?.setup(nftList: nfts, countNft: countNFT, sumNft: sumNFTString)
        viewController?.showIsLoading(false)
    }
    
    private func castResponseToModel(nft: BasketNFTModelResponse) -> NFTBasketModel? {
        guard let url = URL(string: nft.images[0]) else { return nil }
        return NFTBasketModel(
            id: nft.id,
            imageUrl: url,
            name: nft.name,
            rating: nft.rating,
            price: nft.price
        )
    }
    
    func getInfo() {
        viewController?.showIsLoading(true)
        nftService.loadOrder { [weak self] result in
            switch result {
            case .success(let basket):
                self?.basket = basket
            case .failure(_):
                self?.nftList = []
                self?.viewController?.showErrorAlert(title: "Ошибка сети", completion: nil)
            }
        }
    }
    
    private func getNfts() {
        guard let basket else { return }
        let nfts = basket.nfts
        nftList = []
        
        let group = DispatchGroup()
        
        nfts.forEach {
            group.enter()
            nftService.getNftBy(id: $0) { [weak self] result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let nft):
                    self?.nftList.append(nft)
                case .failure(_):
                    break
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            if nfts.count != self.nftList.count {
                self.basket = nil
                self.nftList = []
                self.viewController?.showErrorAlert(title: "Ошибка сети", completion: nil)
            }
            
            self.configViewController()
        }
    }
    
    func removeNftBy(id: String) {
        let nfts = nftList.map({ $0.id }).filter { $0 != id }
        viewController?.showIsLoading(true)
        nftService.updateOrder(nfts: nfts) { [weak self] result in
            switch result {
            case .success(let basket):
                self?.basket = basket
            case .failure(_):
                self?.viewController?.showErrorAlert(title: "Ошибка сети", completion: nil)
            }
        }
    }
    
    func updateSortType(_ type: BasketSortType) {
        basketSortStorage.basketSortType = type
        configViewController()
    }
}
