//
//  ImageListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexey on 01.05.2023.
//

import Foundation
@testable import ImageFeed
import UIKit

final class ImageListViewControllerSpy: ImageListViewControllerProtocol {
    var presenter: ImageFeed.ImageListViewPresenterProtocol?
    var tableViewDidUpdate: Bool = false
    var switchDidChange: Bool = false
    
    var heightsOfRows: [String : CGFloat] = [:]
    
    func updateTableViewAnimated() {
        tableViewDidUpdate = true
    }
    
    func switchToSingleViewController(sender: Any?, viewController: UIViewController) {
        switchDidChange = true
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        
    }
    
    func requestFullSizeImage(viewController: ImageFeed.SingleImageViewController, url: URL) {
        
    }
}
