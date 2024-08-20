import Foundation

struct GetOrderRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct UpdateOrderRequest: NetworkRequest {
    
    let nfts: [String]
    
    var headers: [String : String] = [
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json"
    ]
    
    var httpMethod: HttpMethod = .put
    
    var endpoint: URL? {
        var nftsString = ""
        for (index, nft) in nfts.enumerated() {
            if index == 0 {
                nftsString += "?nfts=\(nft)"
            } else {
                nftsString += "&nfts=\(nft)"
            }
        }

        return URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1" + nftsString)
    }
}
