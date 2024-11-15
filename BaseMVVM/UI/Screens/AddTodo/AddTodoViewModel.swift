//
//  AddTodoViewModel.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 15/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddTodoViewModel: ViewModel{
    private let navigator: AddTodoNavigator
    
    init(navigator: AddTodoNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
    }
    
}
