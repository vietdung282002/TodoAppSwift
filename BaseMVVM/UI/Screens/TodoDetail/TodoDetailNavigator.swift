//
//  AddTodoNavigator.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 15/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import Foundation

class TodoDetailNavigator: Navigator{
    func backHome(){
        navigationController?.popViewController(animated: true)
    }
}
