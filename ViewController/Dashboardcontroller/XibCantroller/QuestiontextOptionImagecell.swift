//
//  QuestiontextOptionImagecell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 24/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class QuestiontextOptionImagecell: UICollectionViewCell {

    
    @IBOutlet weak var lblNon: UILabel!
    
    @IBOutlet weak var imgFour: UIImageView! {
        didSet {
            imgFour.layer.cornerRadius = 5
            imgFour.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgThree: UIImageView! {
        didSet {
            imgThree.layer.cornerRadius = 5
            imgThree.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgtwo: UIImageView! {
        didSet {
            imgtwo.layer.cornerRadius = 5
            imgtwo.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgOne: UIImageView! {
        didSet {
            imgOne.layer.cornerRadius = 5
            imgOne.clipsToBounds = true
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
    
    var questionTextOptionImage: answerQuestion? {
        didSet {
            lblQuestion.text = questionTextOptionImage?.questions_text
            let option_custom = questionTextOptionImage?.option_custom
            if option_custom!.count == 4 {
                let strImgone = questionTextOptionImage!.option0
                url = URL(string: strImgone)
                imgOne.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgTwo = questionTextOptionImage!.option1
                url = URL(string: strImgTwo)
                imgtwo.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgThree = questionTextOptionImage!.option2
                url = URL(string: strImgThree)
                imgThree.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgFour = questionTextOptionImage!.option3
                url = URL(string: strImgFour)
                imgFour.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                lblNon.isHidden = true
                btnFive.isHidden = true
            }
            else if option_custom?.count == 3 {
                let strImgone = questionTextOptionImage!.option0
                url = URL(string: strImgone)
                imgOne.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgTwo = questionTextOptionImage!.option1
                url = URL(string: strImgTwo)
                imgtwo.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgThree = questionTextOptionImage!.option2
                url = URL(string: strImgThree)
                imgThree.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                imgFour.isHidden = true
                btnFour.isHidden = true
                lblNon.isHidden = true
                btnFive.isHidden = true
            }
            else if option_custom?.count == 2 {
                let strImgone = questionTextOptionImage!.option0
                url = URL(string: strImgone)
                imgOne.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgTwo = questionTextOptionImage!.option1
                url = URL(string: strImgTwo)
                imgtwo.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                imgThree.isHidden = true
                btnthree.isHidden = true
                imgFour.isHidden = true
                btnFour.isHidden = true
                lblNon.isHidden = true
                btnFive.isHidden = true
            }
            else {
                let strImgone = questionTextOptionImage!.option0
                url = URL(string: strImgone)
                imgOne.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgTwo = questionTextOptionImage!.option1
                url = URL(string: strImgTwo)
                imgtwo.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgThree = questionTextOptionImage!.option2
                url = URL(string: strImgThree)
                imgThree.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgFour = questionTextOptionImage!.option3
                url = URL(string: strImgFour)
                imgFour.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgFive = questionTextOptionImage!.option4
                lblNon.text = strImgFive
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
