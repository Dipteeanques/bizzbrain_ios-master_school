//
//  RoundedCardView.swift
//  bizzbrains
//
//  Created by Kalu's mac on 14/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

@IBDesignable class RoundedCardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 35
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowColor: UIColor? = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
