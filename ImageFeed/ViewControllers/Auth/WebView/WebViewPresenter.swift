//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Alexey on 28.04.2023.
//

import UIKit

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func didLoad() {
        sentRequestToUnsplashAPI()
        didUpdateProgressValue(0)
    }
    
    func sentRequestToUnsplashAPI() {
        let request = authHelper.authRequest()
        view?.load(request: request)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHidProgres(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHidProgres(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.001
    }
}
