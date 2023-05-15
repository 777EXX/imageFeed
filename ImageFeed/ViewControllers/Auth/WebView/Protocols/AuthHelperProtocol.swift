//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 28.04.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from: URL) -> String?
}
