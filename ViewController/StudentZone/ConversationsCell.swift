//
//  ConversationsCell.swift
//  bizzbrains
//
//  Created by Anques on 30/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class ConversationsCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTimeInfo: UILabel!
    
    //MARK: select Teacher
    @IBOutlet weak var lblName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
