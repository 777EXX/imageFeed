//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexey on 01.05.2023.
//

import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var accountAvatarImage = UIImageView()
    
    func updateAvatar(_ imageView: UIImageView) {
        accountAvatarImage.image = imageView.image
    }
    
    func updateProfileDetails() {
        
    }
    
    var profileService: ImageFeed.ProfileServiceProtocol?
    
    
}
