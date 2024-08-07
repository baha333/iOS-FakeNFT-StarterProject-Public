import Foundation

protocol FavoritesNFTPresenterProtocol: AnyObject {
    var view: FavoritesNFTViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class FavoritesNFTPresenter {
    //MARK:  - Public Properties
    weak var view: FavoritesNFTViewControllerProtocol?
    var nftID: [String]
    var likedNFT: [String]
    var likes: [NFT] = []
    
    // MARK: - Private Properties
    private let favoriteNFTService = FavoriteNFTService.shared
    private let editProfileService: EditProfileService
    
    // MARK: - Initializers
    init(nftID: [String], likedNFT: [String], editProfileService: EditProfileService) {
        self.nftID = nftID
        self.likedNFT = likedNFT
        self.editProfileService = editProfileService
        fetchFavoriteNFTs()
    }
    
    // MARK: - Public Methods
    
    func tapLikeNFT(for nft: NFT) {
        if let index = likedNFT.firstIndex(of: nft.id) {
            likedNFT.remove(at: index)
            likes.removeAll { $0.id == nft.id }
        } else {
            likedNFT.append(nft.id)
            likes.append(nft)
        }
        updateLikes()
    }
    
    func isLiked(id: String) -> Bool {
        return likedNFT.contains(id)
    }
    
    // MARK: - Private Methods
    
    private func fetchFavoriteNFTs() {
        var allNFTs: [NFT] = []
        let group = DispatchGroup()
        
        for id in likedNFT {
            group.enter()
            favoriteNFTService.fetchNFTs(id) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let likes):
                    allNFTs.append(likes)
                case .failure(let error):
                    print("Failed to fetch NFTs: \(error)")
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.likes = allNFTs
            self?.view?.updateFavoriteNFTs(allNFTs)
        }
    }
    
    private func updateLikes() {
        let model = EditProfile(
            name: nil,
            avatar: nil,
            description: nil,
            website: nil,
            likes: likedNFT
        )
        editProfileService.updateProfile(with: model) { [weak self] result in
            switch result {
            case .success:
                print("Успешно обновлено")
                DispatchQueue.main.async {
                    self?.view?.updateFavoriteNFTs(self?.likes)
                }
            case .failure(let error):
                print("Ошибка при обновлении: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - FavoritesNFTPresenterProtocol
extension FavoritesNFTPresenter: FavoritesNFTPresenterProtocol {
    func viewDidLoad() {
        
    }
}