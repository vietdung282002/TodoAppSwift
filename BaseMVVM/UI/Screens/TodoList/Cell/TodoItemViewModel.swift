//
//  TodoItemViewCell.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import Foundation

class TodoCellViewModel: CellViewModel {
    let item: Item
    
    init(item: Item) {
        self.item = item
        super.init()
        self.title.accept(item.name)
        self.imageUrl.accept(item.thumbnail)
    }
}
