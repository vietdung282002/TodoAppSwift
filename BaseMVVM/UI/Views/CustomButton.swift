//
//  CustomButton.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 21/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    var buttonRadius: CGFloat = 25
    var shadowRadius: CGFloat = 10
    var shadowOpacity: Float = 0.8
    var shadowOffset: CGSize = CGSize(width: 10, height: 10)
    var shadowColor: UIColor = .darkGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRadiusAndShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setRadiusAndShadow()
    }
    
    func setRadiusAndShadow() {
        cornerRadius = buttonRadius
        layer.masksToBounds = false
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
    }
}
