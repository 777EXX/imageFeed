//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Alexey on 29.04.2023.
//

import UIKit
import Kingfisher

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileInfoServiceObserver: NSObjectProtocol?
    
    static let didChangeProfileNotification = Notification.Name("ProfileInfoDidRecieved")
    static let didChangeProfileAvatarNotification = Notification.Name("ProfileAvatarDidRecieved")
    
    weak var view: ProfileViewControllerProtocol?
    var profileService: ProfileServiceProtocol?
    var profileImageService: ProfileImageServiceProtocol?
    var alertPresenter: AlertPresenter?
    
    var profile: Profile?
    var avatarURL: String?
    let imageView = UIImageView()
    
    func downloadAvatarImage(_ stringURL: String) {
        guard let url = URL(string: stringURL) else { return }
        imageView.kf.setImage(with: url) { [weak self] _ in
            guard let self = self else { return }
            setupAvatarImage(imageView)
        }
    }
    
    func setupAvatarImage(_ imageView: UIImageView) {
        view?.updateAvatar(imageView)
    }
    
    func showLogoutAlert(controller: UIViewController) {
        let model = LogoutAlertModel(title: "Пока, пока!",
                                     message: "Уверены, что хотите выйти?",
                                     leftButtonText: "Да",
                                     rightButtonText: "Нет") {
            let splashVC = SplashViewController()
            splashVC.modalPresentationStyle = .overFullScreen
            
            controller.present(splashVC, animated: true)
            OAuth2TokenStorage().deleteToken()
            WebViewViewController.clean()
        }
        alertPresenter?.presentLogoutAlert(model)
    }
    
    func fetchProfile() {
        guard let token = OAuth2TokenStorage().token else { return }
        profileService?.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.fetchImageProfile(token: token, username: profile.username)
                NotificationCenter.default.post(
                    name: ProfileViewPresenter.didChangeProfileNotification,
                    object: self,
                    userInfo: ["ProfileInfo": self.profile!])
            case .failure(let error):
                self.alertPresenter?.presentErrorAlert()
                print(error)
            }
        }
    }
    
    func fetchImageProfile(token: String, username: String) {
        profileImageService?.fetchProfileImageURL(username: username, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let avatarURL):
                self.avatarURL = avatarURL
                NotificationCenter.default.post(
                    name: ProfileViewPresenter.didChangeProfileAvatarNotification,
                    object: self,
                    userInfo: ["URL": self.avatarURL!])
            case .failure(let error):
                self.alertPresenter?.presentErrorAlert()
                print(error)
            }
        }
    }
    
    func setupObservers() {
        setupAvatarObserver()
        setupProfileInfoObserver()
    }
    
    func setupAvatarObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileViewPresenter.didChangeProfileAvatarNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.downloadAvatarImage(avatarURL ?? "")
            }
    }
    
    func setupProfileInfoObserver() {
        profileInfoServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileViewPresenter.didChangeProfileNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.view?.updateProfileDetails()
            }
        self.view?.updateProfileDetails()
    }
}
