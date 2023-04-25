//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Alexey on 31.03.2023.
//

import UIKit
import ProgressHUD

class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.show("Loading...")
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
