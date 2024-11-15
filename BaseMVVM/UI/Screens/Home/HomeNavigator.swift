//
//  HomeNavigator.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/21/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation

class HomeNavigator: Navigator {
    func presentSideMenu() {
        
    }
    
    func pushAddTodo() {
        let viewController = AddTodoViewController(nibName: AddTodoViewController.className, bundle: nil)
        let navigator = AddTodoNavigator(with: viewController)
        let viewModel = AddTodoViewModel(navigator: navigator)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}
