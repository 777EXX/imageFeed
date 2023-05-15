import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    let keyChain = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keyChain.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            keyChain.set(newValue!, forKey: Keys.bearerToken.rawValue)
        }
    }
    func deleteToken() {
        keyChain.removeObject(forKey: Keys.bearerToken.rawValue)
    }
}

enum Keys: String {
    case bearerToken
}
