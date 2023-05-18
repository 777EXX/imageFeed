//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Medvedev on 05.05.2023.
//

import Foundation

protocol ProfileServiceProtocol: AnyObject {
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}
