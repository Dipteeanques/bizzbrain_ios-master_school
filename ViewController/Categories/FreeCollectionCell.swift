//
//  FreeCollectionCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class FreeCollectionCell: UICollectionViewCell {
   
    @IBOutlet weak var imgSelected: UIImageView! {
        didSet {
            imgSelected.isSkeletonable = true
            imgSelected.showAnimatedSkeleton()
            imgSelected.layer.cornerRadius = 5
            imgSelected.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgCategory: UIImageView! {
        didSet {
            imgCategory.isSkeletonable = true
            imgCategory.showAnimatedSkeleton()
            imgCategory.layer.cornerRadius = 5
            imgCategory.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblName: UILabel!
}
