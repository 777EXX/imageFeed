//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Alexey on 07.05.2023.
//

import Foundation

struct ErrorAlertModel {
    var title = "Ой, что-то пошло не так"
    var message = "Попробуйте пожалуйста еще раз"
    var buttonText = "Ок"
}

struct LogoutAlertModel {
    var title: String
    var message: String
    var leftButtonText: String
    var rightButtonText: String
    var completion: () -> ()
}
