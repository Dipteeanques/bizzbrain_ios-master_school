//
//  tblDocumentlistCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblDocumentlistCell: UITableViewCell {

    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView! {
        didSet {
            img.isSkeletonable = true
            img.showAnimatedSkeleton()
            img.layer.cornerRadius = 5
            img.clipsToBounds = true
        }
    }
    
    var url: URL?
    
    var Document: DatumDocument? {
        didSet {
            lblTitle.text = Document?.title
            lblDiscription.text = Document?.datumDescription
            let strimage = Document!.image
            url = URL(string: strimage)
            img.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
            img.hideSkeleton()
            img.layer.cornerRadius = 5
            img.clipsToBounds = true
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
