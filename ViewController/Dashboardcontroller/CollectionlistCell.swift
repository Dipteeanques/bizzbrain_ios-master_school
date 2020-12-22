//
//  CollectionlistCell.swift
//  bizzbrains
//
//  Created by Kalu's mac on 19/01/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class CollectionlistCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView? {
          didSet {
            imageView?.isSkeletonable = true
            imageView?.showAnimatedSkeleton()
            imageView?.layer.cornerRadius = 8
            imageView?.clipsToBounds = true
          }
      }
    
      @IBOutlet weak var lblname: UILabel? 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
