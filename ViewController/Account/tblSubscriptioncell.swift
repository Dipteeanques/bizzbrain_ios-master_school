//
//  tblSubscriptioncell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblSubscriptioncell: UITableViewCell {

    @IBOutlet weak var imgStatic: UIImageView! {
        didSet {
            imgStatic.isSkeletonable = true
            imgStatic.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblExpire: UILabel!
    @IBOutlet weak var btnRenew: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
