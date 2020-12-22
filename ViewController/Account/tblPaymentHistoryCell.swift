//
//  tblPaymentHistoryCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 23/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblPaymentHistoryCell: UITableViewCell {

    @IBOutlet weak var lbltotal: UILabel!
    @IBOutlet weak var lblgross: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPricePro: UILabel!
    @IBOutlet weak var lblProName: UILabel!
    @IBOutlet weak var imgPRO: UIImageView! {
        didSet {
            imgPRO.layer.cornerRadius = 5
            imgPRO.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var imgStaticWaich: UIImageView!{
        didSet {
            imgStaticWaich.isSkeletonable = true
            imgStaticWaich.showAnimatedSkeleton()
        }
    }
   
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        //imgPRO.image = nil
    }

}

class PaymentListCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel! 
}
