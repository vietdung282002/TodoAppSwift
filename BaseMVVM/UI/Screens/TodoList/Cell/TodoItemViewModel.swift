//
//  TodoItemViewCell.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import Foundation

class TodoCellViewModel: CellViewModel {
    let todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
        super.init()
        self.title.accept(todo.taskTitle)
        self.category_id.accept(todo.categoryId)
        self.time.accept(todo.time)
        self.isComplete.accept(todo.isComplete)
    }
}
