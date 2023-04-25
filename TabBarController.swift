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
        
        self.viewControllers = [imagesListViewController, profileViewController]
        
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: Resourses.Images.tabBarProfileImage,
                                                        selectedImage: nil)
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: Resourses.Images.tabBarProfileListImage,
                                                           selectedImage: nil)
    }
    
}
