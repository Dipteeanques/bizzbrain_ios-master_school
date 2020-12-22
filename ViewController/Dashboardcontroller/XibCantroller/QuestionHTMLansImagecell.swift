//
//  QuestionHTMLansImagecell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 03/10/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import WebKit

class QuestionHTMLansImagecell: UICollectionViewCell {

    @IBOutlet weak var lblNon: UILabel!
    @IBOutlet weak var optionTop: NSLayoutConstraint!
    @IBOutlet weak var webQuestion: WKWebView!
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
    var questionHTMLOptionImage: answerQuestion? {
        didSet {
            let option_custom = questionHTMLOptionImage?.option_custom
            if option_custom!.count == 4 {
                let strImgone = questionHTMLOptionImage!.option0
                url = URL(string: strImgone)
                imgOne.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgTwo = questionHTMLOptionImage!.option1
                url = URL(string: strImgTwo)
                imgtwo.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgThree = questionHTMLOptionImage!.option2
                url = URL(string: strImgThree)
                imgThree.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgFour = questionHTMLOptionImage!.option3
                url = URL(string: strImgFour)
                imgFour.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                lblNon.isHidden = true
                btnFive.isHidden = true
            }
            else if option_custom?.count == 3 {
                let strImgone = questionHTMLOptionImage!.option0
                url = URL(string: strImgone)
                imgOne.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgTwo = questionHTMLOptionImage!.option1
                url = URL(string: strImgTwo)
                imgtwo.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgThree = questionHTMLOptionImage!.option2
                url = URL(string: strImgThree)
                imgThree.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                imgFour.isHidden = true
                btnFour.isHidden = true
                lblNon.isHidden = true
                btnFive.isHidden = true
            }
            else if option_custom?.count == 2 {
                let strImgone = questionHTMLOptionImage!.option0
                url = URL(string: strImgone)
                imgOne.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgTwo = questionHTMLOptionImage!.option1
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
                let strImgone = questionHTMLOptionImage!.option0
                url = URL(string: strImgone)
                imgOne.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgTwo = questionHTMLOptionImage!.option1
                url = URL(string: strImgTwo)
                imgtwo.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgThree = questionHTMLOptionImage!.option2
                url = URL(string: strImgThree)
                imgThree.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgFour = questionHTMLOptionImage!.option3
                url = URL(string: strImgFour)
                imgFour.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                let strImgFive = questionHTMLOptionImage!.option4
                lblNon.text = strImgFive
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
