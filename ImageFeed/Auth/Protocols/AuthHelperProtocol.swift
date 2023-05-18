//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 05.05.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
