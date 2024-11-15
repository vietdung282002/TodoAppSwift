//
//  Todo.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//
import Foundation
import ObjectMapper

struct Todo {
    var id: Int
    var title: String
    var date: String
    var category: String
    var time: String
    var note: String
    var status: Bool
}

extension Todo{
    static var sampleData = [
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: false),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: false),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: false),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: false),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: false),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: false),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: false),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: false),
        Todo(id: 1, title: "test1",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        Todo(id: 1, title: "test12323",date: "2024",category: "test",time:"12:00",note: "note test",status: true),
        
    ]
}

enum TodoSection: Int, CaseIterable {
    case incomplete
    case complete

    var title: String {
        switch self {
        case .incomplete:
            return "Chưa Hoàn Thành"
        case .complete:
            return "Đã Hoàn Thành"
        }
    }
}

// Chuyển đổi danh sách todo thành dictionary với các mục đã hoàn thành và chưa hoàn thành
let groupedTodos = Dictionary(grouping: Todo.sampleData, by: { $0.status })

// Tạo data source từ groupedTodos
var dataSource: [TodoSection: [Todo]] = [
    .incomplete: groupedTodos[false] ?? [],
    .complete: groupedTodos[true] ?? []
]
