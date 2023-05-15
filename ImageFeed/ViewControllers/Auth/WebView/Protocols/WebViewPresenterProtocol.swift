//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 28.04.2023.
//

import Foundation

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func didLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
