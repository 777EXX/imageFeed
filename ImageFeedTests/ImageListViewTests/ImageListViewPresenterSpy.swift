//
//  ImageListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Alexey on 01.05.2023.
//

import UIKit
@testable import ImageFeed

final class ImageListViewPresenterSpy: ImageListViewPresenterProtocol {
    
    var imagesListService: ImageFeed.ImagesListServiceProtocol?
    var view: ImageFeed.ImageListViewControllerProtocol?
    var dateService: ImageFeed.DateService?
    var viewDidLoad: Bool = false
    var token: String?
    var photos: [ImageFeed.Photo] = []
    
    func setupObservers() {
        viewDidLoad = true
        isTimeToUpdateTableView()
    }
    
    func setLikeButtonImage(isLiked: Bool) -> UIImage {
        let image = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        return image!
    }
    
    func fetchPhotosFromData() {
        let date = dateService?.toDate("2016-05-03T11:00:28-04:00")
        let photo =  Photo(id: "id",
                           size: CGSize(width: 50, height: 50),
                           createdAt: date,
                           welcomeDescription: "welcomeDescription",
                           thumbImageURL: "thumbImageURL",
                           largeImageURL: "largeImageURL",
                           isLiked: true)
        photos.append(photo)
    }
    
    func isTimeToUpdateTableView() {
        view?.updateTableViewAnimated(oldCount: 0, newCount: 0)
    }
    
    func requestFullSizeImage(viewController: ImageFeed.SingleImageViewController, url: URL) {
        
    }
    
    func showAlert(_ error: Error, viewController: UIViewController) {
        
    }
}
