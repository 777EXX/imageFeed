//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Alexey on 01.05.2023.
//

import XCTest
import UIKit
@testable import ImageFeed

final class ImageFeedProfileViewTests: XCTestCase {
    
    let littlePictureForTest = "https://kafel.ee/wp-content/uploads/2019/02/013-duck.png"
    
    func testProfileViewControllerDidLoad() {
        // Given:
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        _ = viewController.view
        // Then:
        XCTAssertTrue(presenter.viewDidLoad)
    }
    
    func testDownloadAvatarImage() {
        // Given:
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        presenter.downloadAvatarImage(littlePictureForTest)
        // Then:
        XCTAssertNotNil(viewController.accountAvatarImage)
    }
    
    func testSetupAvatarImage() {
        // Given:
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Active")
        presenter.setupAvatarImage(imageView)
        // Then:
        XCTAssertEqual(imageView.image, viewController.accountAvatarImage.image)
    }
    
    func testFetchProfileInfo() {
        // Given:
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        let profileService = ProfileServiceStub()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.profileService = profileService
        // When:
        presenter.fetchProfile()
        // Then:
        XCTAssertNotNil(presenter.profile)
    }
    
    func testFetchProfileImageInfo() {
        // Given:
        let presenter = ProfileViewPresenter()
        let profileImageService = ProfileImageServiceStub()
        presenter.profileImageService = profileImageService
        // When:
        presenter.fetchImageProfile(token: OAuth2TokenStorage().token ?? "", username: "username")
        // Then:
        XCTAssertNotNil(presenter.avatarURL)
    }
    
    func testAvatarbserver() {
        // Given:
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        let profileImageService = ProfileImageServiceStub()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.profileImageService = profileImageService
        // When:
        profileImageService.expectedAnswer = littlePictureForTest
        presenter.fetchImageProfile(token: OAuth2TokenStorage().token ?? "", username: "username")
        presenter.setupAvatarObserver()
        // Then:
        XCTAssertTrue(profileImageService.counter >= 1)
    }
}
