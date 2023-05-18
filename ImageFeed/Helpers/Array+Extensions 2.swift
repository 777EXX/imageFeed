//
//  Array Extensions.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 21.04.2023.
//

import Foundation

extension Array {
    mutating func withReplaced(itemAt index: Int, newValue: Element) {
        guard index < count else { return }
        self[index] = newValue
    }
}
