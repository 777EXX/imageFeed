//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 04.05.2023.
//

import Foundation

protocol ProfileImageServiceProtocol: AnyObject {
    func fetchProfileImageURL(username: String, token: String,
                              _ completion: @escaping (Result<String, Error>) -> Void)
}
