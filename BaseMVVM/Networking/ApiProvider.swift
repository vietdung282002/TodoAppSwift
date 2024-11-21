//
//  NetworkManager.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/25/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Supabase

private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

struct ApiProvider {
    private let provider: MoyaProvider<ApiService>
    
    init() {
        let logger = NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))
        provider = MoyaProvider<ApiService>(
            plugins: []
        )
    }
    
    // MARK: - Authorization
    
    func login(email: String, password: String) -> Single<AuthResponse> {
        return provider.rx.request(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .mapObject(AuthResponse.self)
    }
    
    func register(email: String, password: String) -> Single<AuthResponse>{
        return provider.rx.request(.register(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .mapObject(AuthResponse.self)
    }
    
    // MARK: - Profile
    
    func getTodos() -> Single<[Todo]> {
        return provider.rx.request(.getTodos)
            .filterSuccessfulStatusCodes()
            .mapArray(Todo.self)
    }
    
    func getTodo(todoId: Int) -> Single<Todo>{
        return provider.rx.request(.getTodo(todoId: todoId))
            .filterSuccessfulStatusCodes()
            .map { response -> Todo in
                let todoArray = try response.mapArray(Todo.self)
                guard let firstTodo = todoArray.first else {
                    return Todo()
                }
                return firstTodo
            }
    }
    
    func addTodo(taskTitle: String,categoryId: Int,taskNote: String, time: String) -> Single<Void>{
        return provider.rx.request(.addTodo(taskTitle: taskTitle, categoryId: categoryId, taskNote: taskNote, time: time))
            .filterSuccessfulStatusCodes()
            .map{ _ in}
    }
    
    func editTodo(taskTitle: String,categoryId: Int,taskNote: String, time: String,todoId: Int) -> Single<Void>{
        return provider.rx.request(.editTodo(taskTitle: taskTitle, categoryId: categoryId, taskNote: taskNote, time: time, todoId: todoId))
            .filterSuccessfulStatusCodes()
            .map{ _ in}
    }
    
    func checkTodo(todoId: Int, isChecked: Bool) -> Single<Void>{
        return provider.rx.request(.checkTodo(todoId: todoId, isChecked: isChecked))
            .filterSuccessfulStatusCodes()
            .map{_ in}
    }
    
    func deleteTodo(todoId: Int) -> Single<Void>{
        return provider.rx.request(.deleteTodo(todoId: todoId))
            .filterSuccessfulStatusCodes()
            .map{_ in}
    }
}
