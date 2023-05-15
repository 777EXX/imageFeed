//
//  ImageListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 01.05.2023.
//

import UIKit

protocol ImageListViewPresenterProtocol: AnyObject {
    var view: ImageListViewControllerProtocol? { get set }
    var imagesListService: ImagesListServiceProtocol? { get set }
    var dateService: DateService? { get set }
    var photos: [Photo] { get set }
    var token: String? { get }
    func isTimeToUpdateTableView()
    func setLikeButtonImage(isLiked: Bool) -> UIImage
    func setupObservers()
}
