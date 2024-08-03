import Foundation

public struct EditProfile: Encodable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let likes: [String]?
}
