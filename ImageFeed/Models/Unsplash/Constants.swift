//
//  Constants.swift
//  MyImageFeed
//
//  Created by Alexey on 18.03.2023.
//

import Foundation

enum UnsplashParam {
    static let accessKey = "3iLI-LkNkVLdIxO48kWM4x70YaVk8UycuMu9-LrBvgU"
    static let secretKey = "gD94Gnoza9p1dG2wkzSqmzzws1In49EzB8NjsehQa3w"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

enum SegueIdentifier {
    static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    static let showWebViewSegueIdentifier = "ShowWebView"
}
