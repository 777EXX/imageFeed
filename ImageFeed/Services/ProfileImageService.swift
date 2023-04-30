//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Alexey on 03.04.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
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
        
        let task = session.objectTask(for: request) { [weak self] (result:Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let userResult):
                let smallSizeURL = userResult.profileImage.small
                self.avatarURL = smallSizeURL
                completion(.success(self.avatarURL!))
            case .failure(let error):
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
}
