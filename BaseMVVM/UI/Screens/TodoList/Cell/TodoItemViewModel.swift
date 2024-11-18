//
//  TodoItemViewCell.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import Foundation

class TodoCellViewModel: CellViewModel {
    let item: Todo
    
    init(item: Todo) {
        self.item = item
        super.init()
        self.title.accept(item.taskTitle)
        self.category.accept(item.categoryId)
        self.time.accept(item.time)
        self.isComplete.accept(item.isComplete)
    }
}
