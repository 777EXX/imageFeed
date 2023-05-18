//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 17.03.2023.
//

import Foundation

struct Constants {
    static let accessKey = "BuoU3kxenUMrXX8_85xkQuQNgEcu3ik2kEirrH9oOY8"
    static let secretKey = "9Jqn66swu-PVwqnbhjP-19tM5hMI4MBalpC_ceYJSEc"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUrl = "https://api.unsplash.com"
    static let authorizeURl = "https://unsplash.com/oauth/authorize"
    static let urlPathToAuthorize = "/oauth/authorize/native"
    static let urlToFetchAuthToken = "https://unsplash.com/oauth/token"
}
struct Parameters {
    static let client_id = "client_id"
    static let client_secret = "client_secret"
    static let redirect_uri = "redirect_uri"
    static let response_type = "response_type"
    static let code = "code"
    static let scope = "scope"
    static let grantType = "grant_type"
    static let authorizationCode = "authorization_code"
}
