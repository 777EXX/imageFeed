//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Alexey on 06.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let appearances = UITabBarAppearance()
        appearances.backgroundColor = .ypBlack
        tabBar.standardAppearance = appearances
        tabBar.tintColor = .ypWhiteIOS
        
        let imagesListViewController = ImageListViewController()
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        let imageListViewPresenter = ImageListViewPresenter()
        let imageListService = ImagesListService()
        let profileService = ProfileService()
        let profileImageService = ProfileImageService()
        let dateService = DateService()
        let alertPresenter = AlertPresenter(viewController: profileViewController)
        
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        profileViewPresenter.profileService = profileService
        profileViewPresenter.profileImageService = profileImageService
        profileViewPresenter.alertPresenter = alertPresenter
        
        imagesListViewController.presenter = imageListViewPresenter
        imagesListViewController.alertPresenter = alertPresenter
        imageListViewPresenter.dateService = dateService
        imageListViewPresenter.imagesListService = imageListService
        imageListViewPresenter.view = imagesListViewController
        
        imageListService.dateService = dateService
        
        self.viewControllers = [imagesListViewController, profileViewController]
        
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: Resourses.Images.tabBarProfileImage,
                                                        selectedImage: nil)
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: Resourses.Images.tabBarProfileListImage,
                                                           selectedImage: nil)
    }
    
}
