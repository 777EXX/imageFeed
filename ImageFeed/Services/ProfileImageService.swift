//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Alexey on 03.04.2023.
//

import Foundation

final class ProfileImageService: ProfileImageServiceProtocol {
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, token: String,
                              _ completion: @escaping (Result<String, Error>) -> Void)  {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) { (result:Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                guard let smallSizeURL = userResult.profileImage.small else { return }
                completion(.success(smallSizeURL))
            case .failure(let error):
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
}
