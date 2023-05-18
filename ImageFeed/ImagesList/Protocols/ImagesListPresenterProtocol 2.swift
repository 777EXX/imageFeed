//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 05.05.2023.
//

import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var photos: [Photo] { get set }
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListServiceProtocol? { get set }
    func photosObserver()
    func updateTableView()
    func showAlert(vc: UIViewController)
}
