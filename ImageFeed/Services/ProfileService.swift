//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Alexey on 31.03.2023.
//

import Foundation

final class ProfileService: ProfileServiceProtocol {
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let unsplashProfile):
                let bio = unsplashProfile.bio ?? ""
                let profile = Profile(username: unsplashProfile.username,
                                      firstName: unsplashProfile.firstName,
                                      lastName: unsplashProfile.lastName,
                                      bio: bio)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
