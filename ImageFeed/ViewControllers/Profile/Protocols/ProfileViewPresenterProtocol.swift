//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 29.04.2023.
//

import UIKit

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var profileService: ProfileServiceProtocol? { get set }
    var profileImageService: ProfileImageServiceProtocol? { get set }
    var profile: Profile? { get }
    var avatarURL: String? { get }
    func fetchProfile()
    func downloadAvatarImage(_ stringURL: String)
    func setupAvatarImage(_ imageView: UIImageView)
    func showLogoutAlert(controller: UIViewController)
    func setupObservers()
    func setupAvatarObserver()
    func setupProfileInfoObserver()
}
