//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 04.05.2023.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
