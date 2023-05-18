//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 05.05.2023.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}
