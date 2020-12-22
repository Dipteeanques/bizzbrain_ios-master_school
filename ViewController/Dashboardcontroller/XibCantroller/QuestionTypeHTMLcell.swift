//
//  QuestionTypeHTMLcell.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 25/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import WebKit

class QuestionTypeHTMLcell: UICollectionViewCell {

    @IBOutlet weak var webhtml: WKWebView!
    @IBOutlet weak var webOne: WKWebView!
    @IBOutlet weak var webTwo: WKWebView!
    @IBOutlet weak var webThree: WKWebView!
    @IBOutlet weak var webFour: WKWebView!
    @IBOutlet weak var webFive: WKWebView!
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btntwo: UIButton!
    @IBOutlet weak var btnthree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
   
    @IBOutlet weak var btnwebFive: UIButton!
    @IBOutlet weak var btnwebFour: UIButton!
    @IBOutlet weak var btnwebThree: UIButton!
    @IBOutlet weak var btnwebTwo: UIButton!
    @IBOutlet weak var btnwebOne: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
