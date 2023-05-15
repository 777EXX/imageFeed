//
//  AlertService.swift
//  ImageFeed
//
//  Created by Alexey on 07.05.2023.
//

import UIKit

final class AlertPresenter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentErrorAlert() {
        let model = ErrorAlertModel()
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText,
                                   style: .cancel)
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
    
    func presentLogoutAlert(_ model: LogoutAlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let rightAction = UIAlertAction(title: model.rightButtonText,
                                        style: .default)
        let leftAction = UIAlertAction(title: model.leftButtonText,
                                       style: .cancel) { _ in
            model.completion()
        }
        alert.addAction(rightAction)
        alert.addAction(leftAction)
        
        viewController?.present(alert, animated: true)
    }
}
