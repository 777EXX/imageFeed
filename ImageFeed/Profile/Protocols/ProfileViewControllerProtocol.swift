//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 05.05.2023.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar()
    func updateProfileDetails(profile: Profile?)
}
