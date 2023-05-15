//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Alexey on 28.04.2023.
//

import UIKit

final class AuthHelper: AuthHelperProtocol {
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration) {
        self.configuration = .standart
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        
        return URLRequest(url: url)
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: ParametersNames.clientID, value: Constants.accessKey),
            URLQueryItem(name: ParametersNames.redirectUri, value: Constants.redirectURI),
            URLQueryItem(name: ParametersNames.responseType, value: ParametersNames.code),
            URLQueryItem(name: ParametersNames.scope, value: Constants.accessScope)
        ]
        
        return urlComponents.url!
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == Constants.urlPathToAutorize,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == ParametersNames.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
