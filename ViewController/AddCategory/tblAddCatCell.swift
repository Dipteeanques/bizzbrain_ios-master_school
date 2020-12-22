//
//  tblAddCatCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 14/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblAddCatCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView! {
        didSet {
            img.isSkeletonable = true
            img.showAnimatedSkeleton()
            img.layer.cornerRadius = 5
            img.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescribe: UILabel!
    @IBOutlet weak var lblPrice: UILabel! 
    @IBOutlet weak var btnCart: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
