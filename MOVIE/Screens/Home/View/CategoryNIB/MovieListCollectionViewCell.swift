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
    
    lazy var bgView : UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 3
        return vw;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear

        contentView.addSubview(bgView)
        contentView.addSubview(titleLabel)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -8).isActive = true
        bgView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 8).isActive = true
        bgView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4).isActive = true
        bgView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                bgView.backgroundColor = .magenta
            }else {
                bgView.backgroundColor = .clear
            }
        }
    }
}
