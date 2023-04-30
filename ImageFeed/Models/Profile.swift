//
//  Profile.swift
//  ImageFeed
//
//  Created by Alexey on 31.03.2023.
//

import Foundation

struct Profile: Codable {
    let username: String
    let loginName: String
    let firstName: String
    let lastName: String
    let fullName: String
    let bio: String
    
    init(username: String, firstName: String, lastName: String, bio: String) {
        self.username = username
        self.loginName = "@\(username)"
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = "\(firstName) \(lastName)"
        self.bio = bio
    }
}

