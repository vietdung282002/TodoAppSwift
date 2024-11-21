//
//  TodoListNavigator.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import Foundation

class TodoListNavigator: Navigator{
    func pushTodoDetail(todoId: Int, delegate: TodoDetailDelegate){
        let viewController = TodoDetailViewController(nibName: TodoDetailViewController.className, bundle: nil)
        let navigator = TodoDetailNavigator(with: viewController)
        let viewModel = TodoDetailViewModel(navigator: navigator)
        viewModel.todoDetailDelegate = delegate
        viewController.viewModel = viewModel
        viewController.todoId = todoId 
        navigationController?.pushViewController(viewController, animated: true)
    }
}
