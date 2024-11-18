//
//  Todo.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//
import Foundation
import ObjectMapper
import Differentiator

struct Todo: Mappable {
    var todoId: Int = 0
    var createdAt: String = ""
    var taskTitle: String = ""
    var categoryId: Int = 0
    var taskNote: String = ""
    var isComplete: Bool = false
    var userId: String = ""
    var time: String = ""

    // Default initializer cho ObjectMapper
    init?(map: Map) {}
    
    init(todoId: Int, createdAt: String, taskTitle: String, categoryId: Int, taskNote: String, isComplete: Bool, userId: String, time: String) {
            self.todoId = todoId
            self.createdAt = createdAt
            self.taskTitle = taskTitle
            self.categoryId = categoryId
            self.taskNote = taskNote
            self.isComplete = isComplete
            self.userId = userId
            self.time = time
        }

    mutating func mapping(map: Map) {
        todoId       <- map["todo_id"]
        createdAt    <- map["created_at"]
        taskTitle    <- map["task_title"]
        isComplete   <- map["is_complete"]
        taskNote     <- map["task_note"]
        userId       <- map["user_id"]
        categoryId   <- map["category_id"]
        time         <- map["time"]
    }
}


struct TodoSection {
    var header: String
    var items: [Todo]
}

extension TodoSection: SectionModelType {
    typealias Item = Todo
    
    init(original: TodoSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension Todo {
    static var sampleData: [Todo] {
        return [
            Todo(todoId: 1, createdAt: "2024-11-18", taskTitle: "Test 1", categoryId: 1, taskNote: "Note 1", isComplete: true, userId: "12345", time: "12:00"),
            Todo(todoId: 2, createdAt: "2024-11-18", taskTitle: "Test 2", categoryId: 2, taskNote: "Note 2", isComplete: false, userId: "12345", time: "13:00"),
            Todo(todoId: 3, createdAt: "2024-11-18", taskTitle: "Test 3", categoryId: 3, taskNote: "Note 3", isComplete: true, userId: "12345", time: "14:00"),
            Todo(todoId: 4, createdAt: "2024-11-18", taskTitle: "Test 4", categoryId: 4, taskNote: "Note 4", isComplete: false, userId: "12345", time: "15:00"),
            Todo(todoId: 5, createdAt: "2024-11-18", taskTitle: "Test 5", categoryId: 5, taskNote: "Note 5", isComplete: true, userId: "12345", time: "16:00")
        ]
    }
}

let sections = [

    TodoSection(header: "Incomplete", items: Todo.sampleData.filter { $0.isComplete == false }),

    TodoSection(header: "Complete", items: Todo.sampleData.filter { $0.isComplete == true })
]
