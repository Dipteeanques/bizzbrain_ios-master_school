//
//  StudentZoneCell.swift
//  bizzbrains
//
//  Created by Diptee Parmar on 10/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class StudentZoneCell: UICollectionViewCell {
    
    @IBOutlet var colorview: UIView!{
        didSet{
            colorview.layer.cornerRadius = colorview.frame.height/2
            colorview.clipsToBounds = true
        }
    }
    @IBOutlet var img_icon: UIImageView!
    @IBOutlet var lbl_title: UILabel!
    
}
