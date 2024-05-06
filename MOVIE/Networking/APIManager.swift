//
//  APIManager.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/6/24.
//

import Foundation
import Alamofire

enum NetworkError : Error {
    case invalidURLError
    case dataParsingError
    case unknownError
}

class APIManager {
    
    func request<T : Decodable>(urlString : String) async throws -> Result<T,NetworkError> {
        let response =  await AF.request(urlString, interceptor: .retryPolicy)
            .serializingDecodable(T.self)
            .response
        
        switch response.result {
        case .success(let res) : return .success(res)
        case .failure(let AFerr) : return .failure(checkError(err: AFerr))
        }
    }
    
    func checkError(err : AFError) -> NetworkError {
        switch err {
        case .invalidURL(_):
            return .invalidURLError
        case .responseSerializationFailed(_) :
            return .dataParsingError
        default : return .unknownError
        }
    }
}
