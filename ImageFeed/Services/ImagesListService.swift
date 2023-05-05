//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Alexey on 15.04.2023.
//

import UIKit
import ProgressHUD

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        defineCurrentPage()
        
        assert(Thread.isMainThread)
        
        var request = URLRequest.makeHTTPRequest(path: "/photos" + "/?page=\(lastLoadedPage!)", httpMethod: "GET")
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) {
            [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photosResult):
                photosResult.forEach { photo in
                    let date = self.toDate(photo.createdAt)
                    guard let thumbImage = photo.urls.thumb,
                          let fullImage = photo.urls.full else { return }
                    self.photos.append(Photo(id: photo.id,
                                             size: CGSize(width: photo.width, height: photo.height),
                                             createdAt: date,
                                             welcomeDescription: photo.description ?? "",
                                             thumbImageURL: thumbImage,
                                             largeImageURL: fullImage,
                                             isLiked: photo.likedByUser))
                }
                UIBlockingProgressHUD.show()
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": self.photos])
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        task.resume()
        self.task = task
    }
    
    func changeLike(photoID: String, isLiked: Bool, completion: @escaping (Result<Void,Error>) -> Void) {
        let httpMethod = isLiked == true ? "DELETE" : "POST"
        
        var request = URLRequest.makeHTTPRequest(path: "/photos" + "/\(photoID)" + "/like",
                                                 httpMethod: "\(httpMethod)")
        
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { _, response, error in
            if let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200...299 ~= statusCode {
                    completion(.success(Void()))
                } else {
                    print(ProcessingErrors.catchNetworkingError(statusCode: statusCode))
                }
            } else {
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    private func defineCurrentPage() {
        if lastLoadedPage == nil {
            lastLoadedPage = 1
        } else {
            lastLoadedPage! += 1
        }
    }
    
    private func toDate(_ string: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: string)
        return date
    }
}
