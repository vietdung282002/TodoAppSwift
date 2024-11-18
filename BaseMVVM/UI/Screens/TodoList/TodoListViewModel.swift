//
//  TodoListViewModel.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TodoListViewModel: ViewModel{
    let todoCellVMS = BehaviorRelay<[TodoCellViewModel]>(value: [])
    
    private let navigator: TodoListNavigator
    private let todos = BehaviorRelay<[Todo]>(value: [])
    
    init(navigator: TodoListNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
        todos.map { todos -> [TodoCellViewModel] in
            return todos.map { todo -> TodoCellViewModel in
                return TodoCellViewModel(item: todo)
            }
        }.bind(to: todoCellVMS).disposed(by: disposeBag)
    }
    
    func reloadData(){
        fetchTodos()
    }
    
    private func fetchTodos(){
        Application.shared.apiProvider.getTodos()
            .trackActivity(ActivityIndicator())
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    print(response)
                }, onError: { [weak self] error in
                    self?.navigator.showAlert(title: "Error",
                                              message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
}
