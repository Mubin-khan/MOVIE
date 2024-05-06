//
//  PosterCollectionViewCell.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/7/24.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {
    
    lazy var posterImageView : UIImageView = {
        let vw = UIImageView()
        vw.layer.cornerRadius = 8
        vw.clipsToBounds = true
        vw.contentMode = .scaleAspectFill
        vw.backgroundColor = .brown
        return vw
    }()
    
    lazy var loader : UIActivityIndicatorView = {
        let vw = UIActivityIndicatorView()
        vw.style = .medium
        vw.color = .white
        vw.hidesWhenStopped = true
        return vw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        loader.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        loader.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        loader.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
