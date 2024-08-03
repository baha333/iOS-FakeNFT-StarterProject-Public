import Foundation
import ProgressHUD

final class BasketPresenter {
    
    weak var viewController: BasketViewController?
    private let nftService: NftService
    
    init(nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())) {
        self.nftService = nftService
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
        let nfts = nftList.compactMap {
            castResponseToModel(nft: $0)
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
            case .failure(let error):
                break
                // TODO: - 3/3 epic
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
                case .failure(let error):
                    break
                    // TODO: - 3/3 epic
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.configViewController()
        }
    }
    
    func removeNftBy(id: String) {
        let nfts = nftList.map({ $0.id }).filter { $0 != id }
        viewController?.showIsLoading(true)
        nftService.updateOrder(nfts: nfts) { [weak self] result in
            switch result {
            case .success(let basket):
                self?.basket = basket
            case .failure(let error):
                break
                // TODO: - 3/3 epic
            }
        }
    }
}
