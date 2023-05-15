//
//  ProfileImageServiceStub.swift
//  ImageFeedTests
//
//  Created by Alexey on 04.05.2023.
//

import Foundation
@testable import ImageFeed

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let mockError = mockError()
        if token != "" {
            counter += 1
            completion(.success(expectedAnswer))
        } else {
            completion(.failure(mockError))
        }
    }
    
    var expectedAnswer = "yahooo"
    var counter = 0
}
