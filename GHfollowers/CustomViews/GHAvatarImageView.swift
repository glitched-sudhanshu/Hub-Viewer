//
//  GHImageView.swift
//  GHfollowers
//
//  Created by Sudhanshu Ranjan on 14/07/24.
//

import UIKit

class GHAvatarImageView: UIImageView {
    
    let placeHolderImage = UIImage(named: "avatar-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    
}
