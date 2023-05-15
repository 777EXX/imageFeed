//
//  UserResult .swift
//  ImageFeed
//
//  Created by Alexey on 03.04.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ImageSizes

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageSizes: Codable {
    let small: String?
}
