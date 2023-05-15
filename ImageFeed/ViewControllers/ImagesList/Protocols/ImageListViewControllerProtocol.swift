//
//  ImageListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 29.04.2023.
//

import UIKit

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListViewPresenterProtocol? { get set }
    var heightsOfRows: [String:CGFloat] { get set }
    func switchToSingleViewController(sender: Any?, viewController: UIViewController)
    func requestFullSizeImage(viewController: SingleImageViewController, url: URL)
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}
