//
//  SplashView.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 10.05.2023.
//

import UIKit

final class SplashView {
    lazy var logoImage: UIImageView = {
        let element = UIImageView()
        element.image = Resourses.Images.launch
        return element
    }()
}
