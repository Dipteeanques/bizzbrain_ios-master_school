//
//  QuestionTypeTextImageoptionTxtcell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 24/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class QuestionTypeTextImageoptionTxtcell: UICollectionViewCell {

    @IBOutlet weak var lblAnsone: UILabel!
    @IBOutlet weak var lblAnsTwo: UILabel!
    @IBOutlet weak var lblAnsThree: UILabel!
    @IBOutlet weak var lblAnsFour: UILabel!
    @IBOutlet weak var lblAnsFive: UILabel!
    @IBOutlet weak var imageQuestion: UIImageView! {
        didSet {
            imageQuestion.layer.cornerRadius = 5
            imageQuestion.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblQuestion: UILabel!
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
    
    var url: URL?
    
    var questionImageTest: answerQuestion? {
        didSet {
            lblQuestion.text = questionImageTest?.questions_text
            let strImage = questionImageTest?.questions_img
            url = URL(string: strImage!)
            imageQuestion.sd_setImage(with: url, completed: nil)
            let option_custom = questionImageTest?.option_custom
            if option_custom!.count == 4 {
                lblAnsone.text = "A) " + questionImageTest!.option0
                lblAnsTwo.text = "B) " + questionImageTest!.option1
                lblAnsThree.text = "C) " + questionImageTest!.option2
                lblAnsFour.text = "D) " + questionImageTest!.option3
                lblAnsFive.isHidden = true
                btnFive.isHidden = true
            }
            else if option_custom?.count == 3 {
                lblAnsone.text = "A) " + questionImageTest!.option0
                lblAnsTwo.text = "B) " + questionImageTest!.option1
                lblAnsThree.text = "C) " + questionImageTest!.option2
                lblAnsFour.isHidden = true
                btnFour.isHidden = true
                lblAnsFive.isHidden = true
                btnFive.isHidden = true
            }
            else if option_custom?.count == 2 {
                lblAnsone.text = "A) " + questionImageTest!.option0
                lblAnsTwo.text = "B) " + questionImageTest!.option1
                lblAnsThree.isHidden = true
                btnthree.isHidden = true
                lblAnsFour.isHidden = true
                btnFour.isHidden = true
                lblAnsFive.isHidden = true
                btnFive.isHidden = true
            }
            else {
                lblAnsone.text = "A) " + questionImageTest!.option0
                lblAnsTwo.text = "B) " + questionImageTest!.option1
                lblAnsThree.text = "C) " + questionImageTest!.option2
                lblAnsFour.text = "D) " + questionImageTest!.option3
                lblAnsFive.text = "E) " + questionImageTest!.option4
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
