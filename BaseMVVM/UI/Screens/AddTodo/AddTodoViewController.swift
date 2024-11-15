//
//  AddTodoViewController.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 15/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import UIKit

class AddTodoViewController: ViewController<AddTodoViewModel,AddTodoNavigator> {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTitle("Add New Task", subTitle: nil)
        showLeftButton(image: UIImage(named: "BackButton"))
        
        let calendarIcon = UIImageView(image: UIImage(named: "iconCalendar"))
        calendarIcon.contentMode = .scaleAspectFit
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 18))
        calendarIcon.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        paddingView.addSubview(calendarIcon)

        dateTextField.rightView = paddingView
        dateTextField.rightViewMode = .always
        addEndIcon(textField: dateTextField, image: UIImage(named: "iconCalendar"))
        addEndIcon(textField: timeTextField, image: UIImage(named: "iconClock"))
        noteTextView.textContainerInset = UIEdgeInsets(top: 8,left: 5,bottom: 8,right: 5);
    }    
}
