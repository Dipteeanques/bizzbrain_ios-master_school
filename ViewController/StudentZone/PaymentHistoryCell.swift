//
//  PaymentHistoryCell.swift
//  bizzbrains
//
//  Created by Anques on 16/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_invoice_number: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var lbl_paymentmethod: UILabel!
    
    @IBOutlet weak var btn_showreceipt: UIButton!{
        didSet{
            btn_showreceipt.layer.cornerRadius = 5.0
            btn_showreceipt.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var mainview: UIView!{
        didSet{
            mainview.layer.cornerRadius = 5.0
            mainview.clipsToBounds = true
            mainview.layer.borderWidth = 1
            mainview.layer.borderColor = UIColor.gray.cgColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
