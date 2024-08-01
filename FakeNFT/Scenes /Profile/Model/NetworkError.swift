import Foundation

enum NetworkError: Error {
    case invalidRequest
    case decodingError(Error)
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidResponse
}
