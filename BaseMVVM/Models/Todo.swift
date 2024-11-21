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

class Todo: Mappable {
    var todoId: Int?
    var createdAt: String?
    var taskTitle: String?
    var categoryId: Int?
    var taskNote: String?
    var isComplete: Bool = false
    var userId: String?
    var time: String?
    
    // Default initializer cho ObjectMapper
    required init?(map: Map) {}
    
    // Custom initializer
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
    
    init() {}
    
    func mapping(map: Map) {
        todoId       <- map["todo_id"]
        createdAt    <- map["created_at"]
        taskTitle    <- map["task_title"]
        isComplete   <- map["is_complete"]
        taskNote     <- map["task_note"]
        userId       <- map["user_id"]
        categoryId   <- map["category_id"]
        time         <- map["time"]
    }
    
    func formattedTime() -> String? {
        guard let timeString = self.time else { return nil }
        
        let dateFormatter = DateFormatter()
        
        let currentDate = Date()
        let currentCalendar = Calendar.current
        let currentDateWithoutTime = currentCalendar.startOfDay(for: currentDate)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let timeDate = dateFormatter.date(from: timeString) {
            let timeWithoutDate = currentCalendar.startOfDay(for: timeDate)
            
            if currentDateWithoutTime == timeWithoutDate {
                dateFormatter.dateFormat = "hh:mm a"
            } else {
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
            }
            return dateFormatter.string(from: timeDate)
        }
        return nil
    }
    
    func dateFormatted() -> String? {
        guard let timeString = self.time else { return nil }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let timeDate = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: timeDate)
        }
        return nil
    }
    
    func timeFormatted() -> String? {
        guard let timeString = self.time else { return nil }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let timeDate = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: timeDate)
        }
        return nil
    }
    
    func categoryImage(for categoryId: Int?) -> UIImage? {
        switch categoryId {
        case 1:
            return UIImage(named: "CategoryTask")
        case 2:
            return UIImage(named: "CategoryEvent")
        default:
            return UIImage(named: "CategoryGoal")
        }
    }
    
    func description() -> String {
        return """
            Todo ID: \(todoId ?? 0)
            Created At: \(createdAt ?? "N/A")
            Title: \(taskTitle ?? "No Title")
            Category ID: \(categoryId ?? 0)
            Task Note: \(taskNote ?? "No Notes")
            Completed: \(isComplete ? "Yes" : "No")
            User ID: \(userId ?? "N/A")
            Time: \(time ?? "N/A")
            
            """
    }
}

extension Todo: IdentifiableType, Equatable{
    static func == (lhs: Todo, rhs: Todo) -> Bool {
            return lhs.todoId == rhs.todoId &&
                lhs.createdAt == rhs.createdAt &&
                lhs.taskTitle == rhs.taskTitle &&
                lhs.categoryId == rhs.categoryId &&
                lhs.taskNote == rhs.taskNote &&
                lhs.isComplete == rhs.isComplete &&
                lhs.userId == rhs.userId &&
                lhs.time == rhs.time
        }
    
    typealias Identity = Int
    
    var identity: Int{
        return todoId!
    }
}



