//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Alexey on 10.05.2023.
//

import UIKit
@testable import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var profileImageService: ImageFeed.ProfileImageServiceProtocol?
    var viewDidLoad: Bool = false
    var showLogoutAlert: Bool = false
    var presentedViewController: UIViewController?
    
    func showLogoutAlert(vc: UIViewController) {
        showLogoutAlert = true
        presentedViewController = vc
    }
    
    func profileImageObserver() {
        viewDidLoad = true
    }
    
    func profileInfoObserver() {
        
    }
    
    
}
