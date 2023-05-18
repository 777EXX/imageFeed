//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 21.04.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
