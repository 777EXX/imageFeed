//
//  URLRequest + Extension.swift
//  ImageFeed
//
//  Created by Alexey on 31.03.2023.
//

import UIKit

extension URLRequest {
    
    static func makeHTTPRequest(path: String,
                                httpMethod: String,
                                baseURL: String = Constants.defaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: URL(string: baseURL))!)
        request.httpMethod = httpMethod
        
        return request
    }
}

