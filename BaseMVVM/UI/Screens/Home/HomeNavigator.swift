//
//  HomeNavigator.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/21/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation

class HomeNavigator: Navigator {
    func pushAddTodo(delegate: TodoDetailDelegate) {
        let viewController = TodoDetailViewController(nibName: TodoDetailViewController.className, bundle: nil)
        let navigator = TodoDetailNavigator(with: viewController)
        let viewModel = TodoDetailViewModel(navigator: navigator)
        viewModel.todoDetailDelegate = delegate
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}
