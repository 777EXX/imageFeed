import Foundation

struct ProcessingErrors {
    enum NetworkError: Error {
        case information
        case redirection
        case clientError
        case serverError
        case anotherError
        case jsonDecode
        case requestError
        case sessionError
    }
    
    static func catchNetworkingError(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 100...103:
            return NetworkError.information
        case 300...308:
            return NetworkError.redirection
        case 400...499:
            return NetworkError.clientError
        case 500...526:
            return NetworkError.serverError
        default:
            return NetworkError.anotherError
        }
    }
}
