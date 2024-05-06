//
//  MovieListCollectionViewCell.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/6/24.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.font = .systemFont(ofSize: 14)
        lb.backgroundColor = .clear
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
