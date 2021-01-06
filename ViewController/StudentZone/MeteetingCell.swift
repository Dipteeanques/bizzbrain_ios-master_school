//
//  MeteetingCell.swift
//  bizzbrains
//
//  Created by Anques on 29/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class MeteetingCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var btnStart: UIButton!{
        didSet{
            btnStart.layer.cornerRadius = btnStart.frame.height/2
            btnStart.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var view1: UIView!{
        didSet{
            ViewCorner(view: view1)
        }
    }
    @IBOutlet weak var view2: UIView!
    {
        didSet{
            ViewCorner(view: view2)
        }
    }
    @IBOutlet weak var view3: UIView!
    {
        didSet{
            ViewCorner(view: view3)
        }
    }
    @IBOutlet weak var view4: UIView!{
        didSet{
            ViewCorner(view: view4)
        }
    }
    
    @IBOutlet weak var lbl_filtertitle: UILabel!
    @IBOutlet weak var btnradio: UIButton!
    
    //MARK: For OlderMeeting
    @IBOutlet weak var lblDateOlder: UILabel!
    @IBOutlet weak var lblTitleOlder: UILabel!
    @IBOutlet weak var lblTimeOlder: UILabel!
    @IBOutlet weak var lblUrlOlder: UILabel!
    @IBOutlet weak var lblSummaryOlder: UILabel!
    @IBOutlet weak var btnStartOlder: UIButton!{
        didSet{
            btnStartOlder.layer.cornerRadius = btnStartOlder.frame.height/2
            btnStartOlder.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var view1Older: UIView!{
        didSet{
            ViewCorner(view: view1Older)
        }
    }
    @IBOutlet weak var view2Older: UIView!
    {
        didSet{
            ViewCorner(view: view2Older)
        }
    }
    @IBOutlet weak var view3Older: UIView!{
        didSet{
            ViewCorner(view: view3Older)
        }
    }
    @IBOutlet weak var view4Older: UIView!{
        didSet{
            ViewCorner(view: view4Older)
        }
    }
    
    @IBOutlet weak var lbl_filtertitleOlder: UILabel!
    @IBOutlet weak var btnradioOlder: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        ViewCorner(view: view1)
//        ViewCorner(view: view2)
//        ViewCorner(view: view3)
//        ViewCorner(view: view4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func ViewCorner(view:UIView){
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
    }
}
