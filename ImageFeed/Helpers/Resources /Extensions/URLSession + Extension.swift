//
//  URLSession + Extension.swift
//  ImageFeed
//
//  Created by Alexey on 31.03.2023.
//

import UIKit

extension URLSession {
    func data(for request: URLRequest,
              completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let fulFillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200...300  ~= statusCode {
                    fulFillCompletion(.success(data))
                } else {
                    fulFillCompletion(.failure(ProcessingErrors.catchNetworkingError(statusCode: statusCode)))
                }
            } else if error != nil {
                fulFillCompletion(.failure(ProcessingErrors.NetworkError.requestError))
            } else {
                fulFillCompletion(.failure(ProcessingErrors.NetworkError.sessionError))
            }
        }
        task.resume()
        return task
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T,Error>) -> Void) -> URLSessionTask {
            
            let fulFillCompletion: (Result<T, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            let task = dataTask(with: request)  { data, response, error in 
                if let response = response,
                   let data = data,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200...299 ~= statusCode {
                        do {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(T.self, from: data)
                            fulFillCompletion(.success(json))
                        } catch {
                            fulFillCompletion(.failure(error))
                        }
                    } else {
                        print(ProcessingErrors.catchNetworkingError(statusCode: statusCode))
                    }
                } else {
                    completion(.failure(ProcessingErrors.NetworkError.sessionError))
                }
            }
            return task
        }
}
