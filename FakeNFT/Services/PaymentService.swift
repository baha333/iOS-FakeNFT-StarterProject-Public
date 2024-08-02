import Foundation

final class PaymentService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func loadCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        let request = CurrenciesRequest()
        networkClient.send(request: request, type: [CurrencyModel].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func payWithCurrency(id: String, completion: @escaping (Result<OrderResponse, Error>) -> Void) {
        let request = PayRequest(id: id)
        networkClient.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
