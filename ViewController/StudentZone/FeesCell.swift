//
//  FeesCell.swift
//  bizzbrains
//
//  Created by Anques on 15/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class FeesCell: UITableViewCell {

    
    @IBOutlet weak var lbl_feestitle1: UILabel!
    @IBOutlet weak var lbl_fees1: UILabel!
    
    @IBOutlet weak var lbl_feestitle2: UILabel!
    
    @IBOutlet weak var lbl_duedate: UILabel!
    
    @IBOutlet weak var lbl_fees2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


