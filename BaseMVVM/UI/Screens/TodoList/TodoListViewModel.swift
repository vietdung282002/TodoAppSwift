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
import RxDataSources

class TodoListViewModel: ViewModel{
    weak var todoListDelegate: TodoListViewModelDelegate?
    var todoDataSource = RxTableViewSectionedAnimatedDataSource<TodoSection>(configureCell: {(_,_,_,_) in
        fatalError()
    })
    var todos = BehaviorRelay<[Todo]>(value: [])
    
    private let navigator: TodoListNavigator
    private let _todos = BehaviorRelay<[Todo]>(value: [])
    
    init(navigator: TodoListNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
        _todos.asObservable()
            .subscribe(onNext: { todosArray in
                self.todos.accept(todosArray)
            })
            .disposed(by: disposeBag)
    }
    
    func reloadData(){
        fetchTodos(reload: true)
    }
    
    func handleItemTapped(todo: Todo,delegate: TodoDetailDelegate) {
        if let value = todo.todoId {
            let todoId: Int = value
            navigator.pushTodoDetail(todoId: todoId, delegate: delegate)
        }
    }
    
    func checkTodo(todoId: Int,isChecked: Bool){
        Application.shared.apiProvider.checkTodo(todoId: todoId, isChecked: isChecked)
            .trackActivity(loadingIndicator)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    fetchTodos(reload: false)
                }, onError: { [weak self] error in
                    self?.navigator.showAlert(title: "Error",
                                              message: error.localizedDescription)
                }).disposed(by: disposeBag)
    }
    
    func deleteTodo(todoId: Int){
        Application.shared
            .apiProvider
            .deleteTodo(todoId: todoId)
            .trackActivity(loadingIndicator)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    fetchTodos(reload: false)
                }, onError: { [weak self] error in
                    self?.navigator.showAlert(title: "Error",
                                              message: error.localizedDescription)
                }).disposed(by: disposeBag)
    }
    
    private func fetchTodos(reload:Bool){
        if reload{
            self.todoListDelegate?.isLoadingTodo(loading: true)
        }
        Application.shared.apiProvider.getTodos()
            .trackActivity(loadingIndicator)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    if reload{
                        self.todoListDelegate?.isLoadingTodo(loading: false)
                    }
                    _todos.accept(response)
                }, onError: { [weak self] error in
                    self?.navigator.showAlert(title: "Error",
                                              message: error.localizedDescription)
                    if reload{
                        self?.todoListDelegate?.isLoadingTodo(loading: false)
                    }
                }).disposed(by: disposeBag)
    }
    
}
protocol TodoListViewModelDelegate: AnyObject {
    func isLoadingTodo(loading: Bool)
}
