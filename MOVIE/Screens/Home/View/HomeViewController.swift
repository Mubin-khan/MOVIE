//
//  HomeViewController.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/6/24.
//

import UIKit

class HomeViewController: UIViewController {

    let viewModel = MovieViewModel()
    let tableViewCellIdentifier = "MovieListTableViewCell"
    let posterViewCellIdentifier = "PosterTableViewCell"
    var selectedGenreId : Int = 0
    
    lazy var movieListView : UITableView = {
        let vw = UITableView()
        vw.backgroundColor = .clear
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        viewModel.delegate = self
        viewModel.getGenres()
       
        setUpView()
        setupTableView()
    }
    
    private func setUpView(){
        view.backgroundColor = .black
    }
    
    private func setupTableView(){
        view.addSubview(movieListView)
        
        movieListView.register(MovieListTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        movieListView.register(PosterTableViewCell.self, forCellReuseIdentifier: posterViewCellIdentifier)
        
        movieListView.delegate = self
        movieListView.dataSource = self
        view.addSubview(movieListView)
        movieListView.translatesAutoresizingMaskIntoConstraints = false
        movieListView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        movieListView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        movieListView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        movieListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 : 
            if let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as? MovieListTableViewCell {
                if let genres = viewModel.genres {
                    cell.movieDelegate = self
                    cell.setupCell(data: genres)
                }
            return cell
        }
        default :
            if let cell = tableView.dequeueReusableCell(withIdentifier: posterViewCellIdentifier, for: indexPath) as? PosterTableViewCell {
                
                if let movie = viewModel.allMovies[selectedGenreId] {
                    cell.setupCell(data: movie, rowNumber : indexPath.row)
                }
            return cell
        }
        }
       
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height : CGFloat
        switch indexPath.row {
            case 0 : height = 70
            case 1 : height = 150
            default : height = 220
        }
        return height
    }
}


extension HomeViewController : MovieViewModelProtocol {
    func reloadGenres() {
        movieListView.reloadData()
        if let data =  viewModel.genres, data.genres.count > 0 {
            selectedGenreId = data.genres[0].id
            viewModel.getAllMovies(pageNumber: 1, genreId: selectedGenreId)
            viewModel.getPopularMovies(pageNumber: 1, genreId: selectedGenreId)
        }
    }
    
    func reloadAllMovies(genreId : Int) {
        if let cell = movieListView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PosterTableViewCell {
            if let data = viewModel.allMovies[genreId] {
                cell.setupCell(data: data, rowNumber: 1)
                cell.collectionView.reloadData()
            }
        }
    }
    
    func reloadPopularMovies(genreId : Int) {
        if let cell = movieListView.cellForRow(at: IndexPath(row: 2, section: 0)) as? PosterTableViewCell {
            if let data = viewModel.popularMovies[genreId] {
                cell.setupCell(data: data, rowNumber: 2)
                cell.collectionView.reloadData()
            }
        }
    }
    
    func failedWith(error: NetworkError) {
        
    }
}

extension HomeViewController : MovieCategoryProtocol {
    func loadMovies(category: Int) {
        selectedGenreId = category
        viewModel.getAllMovies(pageNumber: 1, genreId: category)
        viewModel.getPopularMovies(pageNumber: 1, genreId: category)
    }
}
