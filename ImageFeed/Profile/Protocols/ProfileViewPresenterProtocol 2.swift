//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 05.05.2023.
//

import UIKit

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func showLogoutAlert(vc: UIViewController)
    func profileImageObserver()
    func profileInfoObserver()
}
