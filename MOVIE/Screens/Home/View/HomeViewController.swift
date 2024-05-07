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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        viewModel.delegate = self
        
        setUpView()
        setupTableView()
        handleNetworkCall()
        setupNavigationbar()
    }
    
    private func setupNavigationbar(){
        self.title = "MOVIE"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func handleNetworkCall(){
        if !NetWorkManager.shared.isNetworkReachable() {
            openAlert(title: "Error", message: "Please enable internet", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
                
            }])
        }
        NetWorkManager.shared.reachabilityManager?.startListening(onUpdatePerforming: { [weak self]_ in
            self?.viewModel.getGenres()
        })
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
        
        movieListView.refreshControl = UIRefreshControl()
        movieListView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    @objc func callPullToRefresh(){
        self.loadMovies(category: selectedGenreId)
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
                
                if indexPath.row == 1 {
                    if let movie = viewModel.allMovies[selectedGenreId] {
                        cell.setupCell(data: movie, rowNumber : indexPath.row)
                    }
                }else {
                    if let movie = viewModel.popularMovies[selectedGenreId] {
                        cell.setupCell(data: movie, rowNumber : indexPath.row)
                    }
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
        endRefreshControll()
        movieListView.reloadData()
        if let data =  viewModel.genres, data.genres.count > 0 {
            selectedGenreId = data.genres[0].id
            if viewModel.allMovies[selectedGenreId] == nil {
                viewModel.getAllMovies(pageNumber: 1, genreId: selectedGenreId)
            }
            if viewModel.popularMovies[selectedGenreId] == nil {
                viewModel.getPopularMovies(pageNumber: 1, genreId: selectedGenreId)
            }
        }
    }
    
    func reloadAllMovies(genreId : Int) {
        endRefreshControll()
        if let cell = movieListView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PosterTableViewCell {
            if let data = viewModel.allMovies[genreId] {
                cell.setupCell(data: data, rowNumber: 1)
                cell.collectionView.reloadData()
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) {
                    cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    func reloadPopularMovies(genreId : Int) {
        endRefreshControll()
        if let cell = movieListView.cellForRow(at: IndexPath(row: 2, section: 0)) as? PosterTableViewCell {
            if let data = viewModel.popularMovies[genreId] {
                cell.setupCell(data: data, rowNumber: 2)
                cell.collectionView.reloadData()
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) {
                    cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    func failedWith(error: NetworkError) {
        endRefreshControll()
        if viewModel.genres == nil {
            openAlert(title: "Error", message: "Something went wrong!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
                
            }])
        }
    }
    
    func endRefreshControll(){
        movieListView.refreshControl?.endRefreshing()
    }
}

extension HomeViewController : MovieCategoryProtocol {
    func loadMovies(category: Int) {
        selectedGenreId = category
        if viewModel.allMovies[selectedGenreId] == nil {
            viewModel.getAllMovies(pageNumber: 1, genreId: selectedGenreId)
        }else {
            if let cell = movieListView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PosterTableViewCell {
                if let data = viewModel.allMovies[selectedGenreId] {
                    cell.setupCell(data: data, rowNumber: 1)
                }
            }
            endRefreshControll()
        }
        if viewModel.popularMovies[selectedGenreId] == nil {
            viewModel.getPopularMovies(pageNumber: 1, genreId: selectedGenreId)
        }else {
            if let cell = movieListView.cellForRow(at: IndexPath(row: 2, section: 0)) as? PosterTableViewCell {
                if let data = viewModel.popularMovies[selectedGenreId] {
                    cell.setupCell(data: data, rowNumber: 2)
                }
            }
            endRefreshControll()
        }
    }
}
