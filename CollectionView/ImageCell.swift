//
//  ImageCell.swift
//  CollectionView
//
//  Created by 江涛 on 2019/8/19.
//  Copyright © 2019 江涛. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var showImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.showImage.layer.borderWidth = 2
        self.showImage.layer.borderColor = UIColor.red.cgColor
    }
}
