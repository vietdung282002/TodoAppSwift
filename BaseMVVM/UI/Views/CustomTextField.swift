//
//  CustomTextField.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 21/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    var textFieldRadius: CGFloat = 7
    var textFieldBorderWidth: CGFloat = 1
    var textFieldBorderColor: UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRadiusAndShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setRadiusAndShadow()
    }
    
    func setRadiusAndShadow() {
        cornerRadius = textFieldRadius
        layer.borderColor = textFieldBorderColor.cgColor
        layer.borderWidth = textFieldBorderWidth
    }

}
