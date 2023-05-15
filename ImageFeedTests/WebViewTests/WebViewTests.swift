//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Alexey on 28.04.2023.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given:
        let webViewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        webViewController.presenter = presenter
        presenter.view = webViewController
        // When:
        _ = webViewController.view
        // Then:
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        // Given:
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper(configuration: .standart)
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        presenter.sentRequestToUnsplashAPI()
        XCTAssertTrue(viewController.loadRequestDidCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // Given:
        let authHelper = AuthHelper(configuration: .standart)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        // When:
        let shouldHideProgress = presenter.shouldHidProgres(for: progress)
        // Then:
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        // Given:
        let authHelper = AuthHelper(configuration: .standart)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        // When:
        let shouldHideProgress = presenter.shouldHidProgres(for: progress)
        // Then:
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        // Given:
        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: configuration)
        // When:
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        // Then:
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains(configuration.authURLString))
    }
    
    func testCodeFromURL() {
        // Given:
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let authHelper = AuthHelper(configuration: .standart)
        // When:
        guard let url = urlComponents?.url else { return }
        guard let code = authHelper.code(from: url) else { return }
        // Then:
        XCTAssertEqual(code, "test code")
    }
}




