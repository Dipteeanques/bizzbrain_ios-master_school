//
//  tblCartsummeryCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 16/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblCartsummeryCell: UITableViewCell {

    @IBOutlet weak var btnDropdown: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblSelectedValue: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewSelect: UIView!
    @IBOutlet weak var lblPriceFor: UILabel!
    @IBOutlet weak var img: UIImageView!
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
