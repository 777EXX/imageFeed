//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Alexey on 01.05.2023.
//

import UIKit
@testable import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var profile: ImageFeed.Profile?
    var avatarURL: String?
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoad: Bool = false
    var stringForDownload = ""
    
    var profileService: ImageFeed.ProfileServiceProtocol?
    
    var profileImageService: ImageFeed.ProfileImageServiceProtocol?
    
    func showAlert(_ viewController: UIViewController) {
        
    }
    
    func setupAvatarObserver() {
        
    }
    
    func setupProfileInfoObserver() {
        
    }
    
    func downloadAvatarImage(_ stringURL: String) {
        
    }
    
    func setupAvatarImage(_ imageView: UIImageView) {
        
    }
    
    func downloadAvatarImage() {
        
    }
    
    func showLogoutAlert(controller: UIViewController) {
        
    }
    
    func setupObservers() {
        viewDidLoad = true
    }
    
    func fetchProfile() {
        
    }

    
 
}
