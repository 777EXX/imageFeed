//
//  ImageServiceStub.swift
//  ImageFeedTests
//
//  Created by Alexey on 04.05.2023.
//

import Foundation
@testable import ImageFeed

final class ImagesServiceStub: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = []
    var photosPageDidFetched: Bool = false
    var dateService: DateService?
    
    func fetchPhotosNextPage(_ token: String?) {
        photosPageDidFetched = true
    }
    
    func changeLike(photoID: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func addPhotos() {
        let date1 = dateService?.toDate("2016-05-03T11:00:28-04:00")
        let photo1 =  Photo(id: "id",
                           size: CGSize(width: 50, height: 50),
                           createdAt: date1,
                           welcomeDescription: "welcomeDescription",
                           thumbImageURL: "thumbImageURL",
                           largeImageURL: "largeImageURL",
                           isLiked: true)
        
        let date2 = dateService?.toDate("2018-05-03T11:00:28-04:00")
        let photo2 =  Photo(id: "id",
                           size: CGSize(width: 50, height: 50),
                           createdAt: date2,
                           welcomeDescription: "welcomeDescription",
                           thumbImageURL: "thumbImageURL",
                           largeImageURL: "largeImageURL",
                           isLiked: true)
        photos.append(photo1)
        photos.append(photo2)
    }
}
