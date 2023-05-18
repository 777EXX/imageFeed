//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 05.05.2023.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}
