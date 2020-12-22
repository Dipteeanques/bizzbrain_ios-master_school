//
//  IconCollectionViewCell.swift
//  bizzbrains
//
//  Created by Kalu's mac on 28/01/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet var colorview: UIView!{
        didSet{
            colorview.layer.cornerRadius = 5
            colorview.clipsToBounds = true
        }
    }
}
