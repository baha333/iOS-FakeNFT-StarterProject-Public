import Foundation

struct OrderResponse: Decodable {
    let id: String
    let orderId: String
    let success: Bool
}
