//
//  QuestionHTMLAnsTextCell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 03/10/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import WebKit

class QuestionHTMLAnsTextCell: UICollectionViewCell {

    
    @IBOutlet weak var lblTop: NSLayoutConstraint!
    @IBOutlet weak var webQuestion: WKWebView!
    @IBOutlet weak var lblAnsone: UILabel!
    @IBOutlet weak var lblAnsTwo: UILabel!
    @IBOutlet weak var lblAnsThree: UILabel!
    @IBOutlet weak var lblAnsFour: UILabel!
    @IBOutlet weak var lblAnsFive: UILabel!
    
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btntwo: UIButton!
    @IBOutlet weak var btnthree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    @IBOutlet weak var btnE: UIButton!
    
    var questionHTMLAnstxt: answerQuestion? {
        didSet {
            let option_custom = questionHTMLAnstxt?.option_custom
            if option_custom!.count == 4 {
                lblAnsone.text = "A) " + questionHTMLAnstxt!.option0
                lblAnsTwo.text = "B) " + questionHTMLAnstxt!.option1
                lblAnsThree.text = "C) " + questionHTMLAnstxt!.option2
                lblAnsFour.text = "D) " + questionHTMLAnstxt!.option3
                lblAnsFive.isHidden = true
                btnFive.isHidden = true
            }
            else if option_custom?.count == 3 {
                lblAnsone.text = "A) " + questionHTMLAnstxt!.option0
                lblAnsTwo.text = "B) " + questionHTMLAnstxt!.option1
                lblAnsThree.text = "C) " + questionHTMLAnstxt!.option2
                lblAnsFour.isHidden = true
                btnFour.isHidden = true
                lblAnsFive.isHidden = true
                btnFive.isHidden = true
            }
            else if option_custom?.count == 2 {
                lblAnsone.text = "A) " + questionHTMLAnstxt!.option0
                lblAnsTwo.text = "B) " + questionHTMLAnstxt!.option1
                lblAnsThree.isHidden = true
                btnthree.isHidden = true
                lblAnsFour.isHidden = true
                btnFour.isHidden = true
                lblAnsFive.isHidden = true
                btnFive.isHidden = true
            }
            else {
                lblAnsone.text = "A) " + questionHTMLAnstxt!.option0
                lblAnsTwo.text = "B) " + questionHTMLAnstxt!.option1
                lblAnsThree.text = "C) " + questionHTMLAnstxt!.option2
                lblAnsFour.text = "D) " + questionHTMLAnstxt!.option3
                lblAnsFive.text = "E) " + questionHTMLAnstxt!.option4
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
