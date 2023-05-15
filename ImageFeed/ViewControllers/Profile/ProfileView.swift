//
//  ProfileViews.swift
//  ImageFeed
//
//  Created by Alexey on 29.04.2023.
//

import UIKit

final class ProfileView {
    
    lazy var accountAvatarImage: UIImageView = {
        let imageViews = UIImageView()
        let image = Resourses.Images.accountAvatar
        
        imageViews.layer.cornerRadius = 35
        imageViews.layer.masksToBounds = true
        
        return imageViews
    }()
    lazy var accountFullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resourses.Colors.ypWhiteOS
        label.font = Resourses.Fonts.SFProTextBold
        
        return label
    }()
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resourses.Colors.ypGray
        label.font = Resourses.Fonts.SFProTextRegular
        
        return label
    }()
    
    lazy var accountDescription: UILabel = {
        let label = UILabel()
        label.textColor = Resourses.Colors.ypWhite
        label.font = Resourses.Fonts.SFProTextRegular
        
        return label
    }()
    
    lazy var accountLogoutButton: UIButton = {
        let button = UIButton()
        let image = Resourses.Images.accountLogoutButton
        button.setImage(image, for: .normal)
        button.accessibilityIdentifier = "LogoutButton"
        
        return button
    }()
    
    var downloadGradientImage: CAGradientLayer = {
        let layer = CAGradientLayer()
        
        return layer
    }()
}
