//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 29.04.2023.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    var profileService: ProfileServiceProtocol? { get set }
    func updateAvatar(_ imageView: UIImageView)
    func updateProfileDetails()
}
