//
//  ProfileServiceStub.swift
//  ImageFeedTests
//
//  Created by Alexey on 04.05.2023.
//

import Foundation
@testable import ImageFeed

final class ProfileServiceStub: ProfileServiceProtocol {
    var expectedAnswer = Profile(username: "testUsername",
                                 firstName: "testFirstName",
                                 lastName: "testlastName",
                                 bio: "testBio")
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, Error>) -> Void) {
        let mockError = mockError()
        if token != "" {
            completion(.success(expectedAnswer))
        } else {
            completion(.failure(mockError))
        }
    }
}
