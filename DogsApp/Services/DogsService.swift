//
//  DogsService.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import Foundation

protocol DogsService {
    // Como eu sei que foi um erro ?
    func fetchBreeds(callback: @escaping ([Breed]) -> Void)
    // Agora eu tenho como tomar alguma acao caso venha um erro
    func fetchDogImages(forBreed breed: Breed, callback: @escaping (Result<[String], APIError>) -> Void)
}

enum APIError: Error {
    case invalidData, parseError(String), customError(Error)
}

struct APIWrapper: Codable {
    let status: String
    let message: [String]
}


final class DogsAPI {
    
    let baseApiUrl = "https://dog.ceo/api/"
    
    enum Endpoints {
        case breeds
        case dogImages(Breed)
        
        var path: String {
            switch self {
            case .breeds:
                return "breeds/list"
            case .dogImages(let breed):
                return "breed/\(breed.name)/images"
            }
        }
    }
    
    fileprivate func decode<T: Decodable>(data: Data?, asType: T.Type) throws -> T {
        guard let data = data else {
            throw APIError.invalidData
        }
        let decoder = JSONDecoder()
        do {
            let decodableResponse = try decoder.decode(T.self, from: data)
            return decodableResponse
        }catch {
            throw APIError.parseError(error.localizedDescription)
        }
    }
    
    fileprivate func request(endpoint: Endpoints,callback: @escaping (Result<APIWrapper, APIError>) -> Void) {
        let endpoint = URL(string: "\(baseApiUrl)\(endpoint.path)")!
        let request = URLRequest(url: endpoint)
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                callback(.error(APIError.customError(error)))
                return
            }
            guard let data = data else {
                callback(.error(APIError.invalidData))
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodableResponse = try decoder.decode(APIWrapper.self, from: data)
                callback(.success(decodableResponse))
            }catch {
                callback(.error(APIError.parseError(error.localizedDescription)))
            }
        }
        task.resume()
    }

}

extension DogsAPI: DogsService {
    func fetchBreeds(callback: @escaping ([Breed]) -> Void) {
        
        request(endpoint: .breeds) { result in
            switch result {
            case .success(let apiWrapper):
                let breeds = apiWrapper.message.map { Breed(name: $0) }
                DispatchQueue.main.async {
                    callback(breeds)
                }
            case .error:
                DispatchQueue.main.async {
                    callback([])
                }
            }
        }
        
    }
    
    func fetchDogImages(forBreed breed: Breed, callback: @escaping (Result<[String], APIError>) -> Void) {
        request(endpoint: .dogImages(breed)) { result in
            switch result {
            case .success(let apiWrapper):
                DispatchQueue.main.async {
                    callback(.success(apiWrapper.message))
                }
            case .error(let error):
                DispatchQueue.main.async {
                    callback(.error(error))
                }
            }
        }
    }
}
