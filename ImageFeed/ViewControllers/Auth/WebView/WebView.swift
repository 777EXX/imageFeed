//
//  WebViews.swift
//  ImageFeed
//
//  Created by Alexey on 28.04.2023.
//

import UIKit
import WebKit

final class WebView {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .ypWhiteIOS
        webView.accessibilityIdentifier = "UnsplashWebView"
        
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .ypBlack
        
        return progressView
    }()
    
    lazy var didTapBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Resourses.Images.backButtonBlack, for: .normal)
        button.tintColor = .ypBlack
        
        return button
    }()
}
