//
//  ItemCell.swift
//  RappiLikeDropAnimation
//
//  Created by Abraham Barcenas on 10/31/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    func configureCell(name: String, image: UIImage){
        lblName.text = name
        imgItem.image = image
        imgItem.tag = 5
    }
    
}
