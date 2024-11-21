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

protocol TodoDetailDelegate: AnyObject{
    func onFinish()
}

class TodoDetailViewModel: ViewModel{
    weak var todoDetailDelegate: TodoDetailDelegate?
    private let navigator: TodoDetailNavigator
    
    var todo = BehaviorRelay<Todo>(value: Todo())
    private let _todo = BehaviorRelay<Todo>(value: Todo())
    
    init(navigator: TodoDetailNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
        _todo.asObservable()
            .subscribe(onNext: { todo in
                self.todo.accept(todo)
            })
            .disposed(by: disposeBag)
    }
    func loadTodo(todoId: Int){
        fetchTodo(todoId: todoId)
    }
    
    private func fetchTodo(todoId: Int){
        Application.shared
            .apiProvider
            .getTodo(todoId: todoId)
            .trackActivity(loadingIndicator)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    _todo.accept(response)
                }, onError: { [weak self] error in
                    self?.navigator.showAlert(title: "Error",
                                              message: error.localizedDescription)
                }).disposed(by: disposeBag)
    }
    
    func editTodo(taskTitle: String,categoryId: Int,taskNote: String, time: String){
        if taskTitle.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Detail.TaskTitle.Empty".localized())
            return
        }
        
        if categoryId == 0 {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Detail.Category.Empty".localized())
            return
        }
        
        Application.shared
            .apiProvider
            .editTodo(taskTitle: taskTitle, categoryId: categoryId, taskNote: taskNote, time: time, todoId: _todo.value.todoId!)
            .trackActivity(loadingIndicator)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    navigator.backHome()
                    self.todoDetailDelegate?.onFinish()
                }, onError: { [weak self] error in
                    self?.navigator.showAlert(title: "Error",
                                              message: error.localizedDescription)
                }).disposed(by: disposeBag)
    }
    
    func addTodo(taskTitle: String,categoryId: Int,taskNote: String, time: String){
        if taskTitle.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Detail.TaskTitle.Empty".localized())
            return
        }
        
        if categoryId == 0 {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Detail.Category.Empty".localized())
            return
        }
        
        Application.shared
            .apiProvider
            .addTodo(taskTitle: taskTitle, categoryId: categoryId, taskNote: taskNote, time: time)
            .trackActivity(loadingIndicator)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    navigator.backHome()
                    self.todoDetailDelegate?.onFinish()
                }, onError: { [weak self] error in
                    self?.navigator.showAlert(title: "Error",
                                              message: error.localizedDescription)
                }).disposed(by: disposeBag)
    }
}
