//
//  PosterTableViewCell.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/7/24.
//

import UIKit

class PosterTableViewCell: UITableViewCell {

    var data : MovieModel?
    let listcollectionviewcellIdentifier = "PosterCollectionViewCell"
    var currentRow = 1
    
    lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.text = "Popular Movies"
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 18, weight: .bold)
        return lb
    }()
    
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
        
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: listcollectionviewcellIdentifier)
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func setupCell(data : MovieModel, rowNumber : Int) {
        self.data = data
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        if rowNumber == 2 {
            contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 10).isActive = true
           
        }else {
            titleLabel.removeFromSuperview()
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        }
    }
}

extension PosterTableViewCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = data?.results.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listcollectionviewcellIdentifier, for: indexPath) as? PosterCollectionViewCell {
            
            if let data {
                cell.posterImageView.image = nil
                cell.loader.startAnimating()
                let urlString = NetworkConstant.shared.getImageUrl(path: data.results[indexPath.row].posterPath)
                cell.posterImageView.cacheImage(urlString: urlString){
                    cell.loader.stopAnimating()
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
