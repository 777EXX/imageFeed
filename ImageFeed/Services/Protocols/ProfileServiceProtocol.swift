//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Alexey on 04.05.2023.
//

import Foundation

protocol ProfileServiceProtocol: AnyObject {
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}
