//
//  ImageListServiceProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 04.05.2023.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    var photos: [Photo] { get }
    var dateService: DateService? { get set }
    func fetchPhotosNextPage(_ token: String?)
    func changeLike(photoID: String, isLiked: Bool, completion: @escaping (Result<Void,Error>) -> Void)
}
