//
//  MovieListTableViewCell.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/7/24.
//

import UIKit

protocol MovieCategoryProtocol : AnyObject {
    func loadMovies(category : Int)
}

class MovieListTableViewCell: UITableViewCell {
    
    weak var movieDelegate : MovieCategoryProtocol?
    var data : GenreModel?
    let listcollectionviewcellIdentifier = "MovieListCollectionViewCell"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.showsHorizontalScrollIndicator = false
        vw.showsVerticalScrollIndicator = false
        vw.backgroundColor = .clear
       return vw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: listcollectionviewcellIdentifier)
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(data : GenreModel) {
        self.data = data
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension MovieListTableViewCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = data?.genres.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listcollectionviewcellIdentifier, for: indexPath) as? MovieListCollectionViewCell {
            
            if let data {
                cell.titleLabel.text = data.genres[indexPath.row].name
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let data {
            let str = data.genres[indexPath.row].name
            let size: CGSize = str.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])

            return CGSize(width: size.width + 20, height: collectionView.bounds.size.height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = data?.genres {
            movieDelegate?.loadMovies(category: data[indexPath.row].id)
        }
    }
}
