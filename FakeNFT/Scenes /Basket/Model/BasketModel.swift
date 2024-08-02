import Foundation

struct BasketModel: Decodable {
    let nfts: [String]
    let id: String
}

struct BasketNFTModelResponse: Decodable {
    let id: String
    let images: [String]
    let name: String
    let rating: Int
    let price: Double
}
