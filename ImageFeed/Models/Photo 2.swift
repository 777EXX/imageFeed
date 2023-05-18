//
//  Photo.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 17.04.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
