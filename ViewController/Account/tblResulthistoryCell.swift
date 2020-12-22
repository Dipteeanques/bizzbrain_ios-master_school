//
//  tblResulthistoryCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 24/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblResulthistoryCell: UITableViewCell {

    @IBOutlet weak var imgStaticWatch: UIImageView! {
        didSet {
            imgStaticWatch.isSkeletonable = true
            imgStaticWatch.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var lblStaticmark: UILabel!
    @IBOutlet weak var lblStaticRight: UILabel!
    @IBOutlet weak var lblStaticQuetion: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
