//
//  CollectionSubscriberCell.swift
//  bizzbrains
//
//  Created by Kalu's mac on 25/01/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class CollectionSubscriberCell: UICollectionViewCell {
    
    @IBOutlet weak var viewSubSribe: UIView!
    @IBOutlet weak var image: UIImageView! {
        didSet {
            image.isSkeletonable = true
            image.showAnimatedSkeleton()
            image.layer.cornerRadius = 15
            image.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel! 
    
}
