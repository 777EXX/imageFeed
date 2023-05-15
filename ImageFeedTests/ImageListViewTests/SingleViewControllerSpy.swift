//
//  SingleViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexey on 05.05.2023.
//

import UIKit

final class SingleViewControllerSpy: UIViewController {
    var didLoad: Bool = false
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool, completion: (() -> Void)? = nil) {
        didLoad = true
    }
}
