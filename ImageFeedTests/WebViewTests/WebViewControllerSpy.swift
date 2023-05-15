//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexey on 29.04.2023.
//

import Foundation
@testable import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestDidCalled: Bool = false

    
    func load(request: URLRequest) {
        loadRequestDidCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
