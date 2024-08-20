import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias OrderCompletion = (Result<BasketModel, Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadOrder(completion: @escaping OrderCompletion)
    func getNftBy(id: String, completion: @escaping (Result<BasketNFTModelResponse, Error>) -> Void)
    func updateOrder(nfts: [String], completion: @escaping OrderCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNftBy(id: String, completion: @escaping (Result<BasketNFTModelResponse, Error>) -> Void) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: BasketNFTModelResponse.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadOrder(completion: @escaping OrderCompletion) {
        let request = GetOrderRequest()
        networkClient.send(request: request, type: BasketModel.self) { result in
            switch result {
            case .success(let basket):
                completion(.success(basket))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(nfts: [String], completion: @escaping OrderCompletion) {
        let request = UpdateOrderRequest(nfts: nfts)
        networkClient.send(request: request, type: BasketModel.self) { result in
            switch result {
            case .success(let basket):
                completion(.success(basket))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
