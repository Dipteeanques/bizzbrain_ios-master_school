//
//  tblSearchCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 14/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblSearchCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
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
