//
//  AssignmentTblCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 04/05/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class AssignmentTblCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var dateView: UIView! {
        didSet {
            dateView.layer.cornerRadius = dateView.frame.size.height / 2
            dateView.clipsToBounds = true
        }
    }
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblztitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
