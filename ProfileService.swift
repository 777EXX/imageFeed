//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Alexey on 31.03.2023.
//

import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    fileprivate (set) var profile: Profile? 
    
    private let session = URLSession.shared
    private let token = OAuth2TokenStorage().token
    private var task: URLSessionTask?
    
    private init(profile: Profile? = nil, task: URLSessionTask? = nil) {
        self.profile = profile
        self.task = task
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            return 
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) {
            [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let unsplashProfile):
                let bio = unsplashProfile.bio ?? ""
                self.profile = Profile(username: unsplashProfile.username,
                                       firstName: unsplashProfile.firstName,
                                       lastName: unsplashProfile.lastName,
                                       bio: bio)
                completion(.success(self.profile!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    private func object(for request: URLRequest,
                completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return session.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result {
                    try decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
