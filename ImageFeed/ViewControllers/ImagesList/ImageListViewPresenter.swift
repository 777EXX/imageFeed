//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Alexey on 29.04.2023.
//

import UIKit
import ProgressHUD
import Kingfisher

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    
    private var profileInfoServiceObserver: NSObjectProtocol?
    private var profileInfoObserver: NSObjectProtocol?
    
    weak var view: ImageListViewControllerProtocol?
    var imagesListService: ImagesListServiceProtocol?
    var dateService: DateService?
    var photos: [Photo] = []
    var token: String?
    
    func isTimeToUpdateTableView() {
        guard let imagesListService = imagesListService else { return }
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func setLikeButtonImage(isLiked: Bool) -> UIImage {
        let image = isLiked ? Resourses.Images.likeActive : Resourses.Images.likeInactive
        return image!
    }
    
    func setupObservers() {
        setupTokenObserver()
        setupPhotosObserver()
    }
    
    private func setupTokenObserver() {
        UIBlockingProgressHUD.show()
        profileInfoObserver = NotificationCenter.default.addObserver(
            forName: SplashViewController.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                let token = OAuth2TokenStorage().token
                self.token = token
                self.imagesListService?.fetchPhotosNextPage(self.token)
            }
        let token = OAuth2TokenStorage().token
        self.token = token
        imagesListService?.fetchPhotosNextPage(token)
    }
    
    private func setupPhotosObserver() {
        profileInfoServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.isTimeToUpdateTableView()
            }
    }
}
