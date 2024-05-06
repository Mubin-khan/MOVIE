//
//  NetworkConstant.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/6/24.
//

import Foundation

class NetworkConstant {
    static let shared = NetworkConstant()
    private init(){}
    
    public var apiKey : String {
        get {
            return "f7dfff12e8a362f66f7b229287051427"
        }
    }
    
    public var serverAddress : String {
        get {
            return "https://api.themoviedb.org/3/"
        }
    }
    
    public var imageServer : String {
        get {
            return "https://image.tmdb.org/t/p/w500"
        }
    }
    
    public var getGenre : String {
        get {
            return "\(serverAddress)genre/movie/list?api_key=\(apiKey)"
        }
    }
    
    public func getMoviePath(pageNumber : Int, genreId : Int) -> String {
        "\(serverAddress)discover/movie?api_key=\(apiKey)&language=en-US&include_adult=false&include_video=false&page=\(pageNumber)&with_genres=\(genreId)"
    }
    
    public func getPopularMoviePath(pageNumber : Int, genreId : Int) -> String {
        "\(serverAddress)discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(pageNumber)&with_genres=\(genreId)"
    }
    
    public func getImageUrl(path : String) -> String {
        return imageServer+path
    }
}
