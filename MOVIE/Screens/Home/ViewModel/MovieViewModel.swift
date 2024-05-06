//
//  MovieViewModel.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/6/24.
//

import Foundation

protocol MovieViewModelProtocol : AnyObject {
    func reloadGenres()
    func reloadAllMovies(genreId : Int)
    func reloadPopularMovies(genreId : Int)
    func failedWith(error : NetworkError)
}

@MainActor
class MovieViewModel {
    private let manager = APIManager()
    weak var delegate : MovieViewModelProtocol?
    
    var genres : GenreModel? {
        didSet {
            delegate?.reloadGenres()
        }
    }
    
    var allMovies : [Int : MovieModel] = [:] {
        didSet {
//            delegate?.reloadAllMovies()
        }
    }
    
    var popularMovies : [Int : MovieModel] = [:] {
        didSet {
//            delegate?.reloadPopularMovies()
        }
    }
    
    func getGenres() {
        Task {
            do {
                let result : Result< GenreModel, NetworkError> = try await manager.request(urlString: NetworkConstant.shared.getGenre)
                switch result {
                case .success(let res) :
                    genres = res
                    print(res)
                case .failure(let er) :
                    delegate?.failedWith(error: er)
                }
               
            } catch {
                delegate?.failedWith(error: .unknownError)
            }
        }
    }
    
    func getAllMovies(pageNumber : Int, genreId : Int) {
        Task {
            do {
                let result : Result< MovieModel, NetworkError> = try await manager.request(urlString: NetworkConstant.shared.getMoviePath(pageNumber: pageNumber, genreId: genreId))
                switch result {
                case .success(let res) :
                    allMovies[genreId] = res
                    delegate?.reloadAllMovies(genreId: genreId)
                case .failure(let er) :
                    delegate?.failedWith(error: er)
                }
               
            } catch {
                delegate?.failedWith(error: .unknownError)
            }
        }
    }
    
    func getPopularMovies(pageNumber : Int, genreId : Int) {
        Task {
            do {
                let result : Result< MovieModel, NetworkError> = try await manager.request(urlString: NetworkConstant.shared.getPopularMoviePath(pageNumber: pageNumber, genreId: genreId))
                switch result {
                case .success(let res) :
                    popularMovies[genreId] = res
                    delegate?.reloadPopularMovies(genreId: genreId)
                case .failure(let er) :
                    delegate?.failedWith(error: er)
                }
               
            } catch {
                delegate?.failedWith(error: .unknownError)
            }
        }
    }
}
