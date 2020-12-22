//
//  CollectionCategoriesCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 13/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import SkeletonView

class CollectionCategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var lblSubscribe: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var image: UIImageView! {
        didSet {
            image.isSkeletonable = true
            image.showAnimatedSkeleton()
            image.layer.cornerRadius = 15
            image.clipsToBounds = true
        }
    }
}


