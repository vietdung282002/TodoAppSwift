//
//  AppAPI.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/25/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Alamofire

enum ApiService {
    
    // MARK: - Authentication
    case login(email: String, password: String)
    case register(email: String, password: String)
    case getTodos
    case getTodo(todoId: Int)
    case addTodo(taskTitle: String,categoryId: Int,taskNote: String, time: String)
    case editTodo(taskTitle: String,categoryId: Int,taskNote: String, time: String,todoId: Int)
    case checkTodo(todoId: Int, isChecked: Bool)
    case deleteTodo(todoId: Int)
}

extension ApiService: TargetType {
    
    var baseURL: URL {
        return URL(string: Configs.Network.supabaseBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .login( _, _):
            return "auth/v1/token"
        case .register( _, _):
            return "auth/v1/signup"
        case .getTodos, .getTodo, .addTodo, .editTodo, .checkTodo, .deleteTodo:
            return "rest/v1/Todo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .addTodo:
            return .post
        case .editTodo, .checkTodo:
            return .patch
        case .deleteTodo:
            return .delete
        default:
            return .get
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = AuthManager.shared.token?.accessToken {
            return ["apikey": "\(Configs.Network.supabaseApiKey)",
                    "Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"
            ]
        }
        return ["apikey": "\(Configs.Network.supabaseApiKey)",
                "Content-Type": "application/json"]
    }
    
    var parameters: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        case .login(let email, let password):
            params["email"] = email
            params["password"] = password
        case .register(let email, let password):
            params["email"] = email
            params["password"] = password
        case .addTodo(let taskTitle,let categoryId,let taskNote,let time):
            params["task_title"] = taskTitle
            params["category_id"] = categoryId
            params["task_note"] = taskNote
            params["time"] = time
            params["user_id"] = UserManager.shared.currentUser.value?.id
        case .editTodo(let taskTitle,let categoryId,let taskNote,let time, _):
            params["task_title"] = taskTitle
            params["category_id"] = categoryId
            params["task_note"] = taskNote
            params["time"] = time
        case .checkTodo(_,let isChecked):
            params["is_complete"] = isChecked
        default: break
        }
        return params
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        switch self {
        case .login:
            let urlParameters: [String: Any] = ["grant_type": "password"]
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: urlParameters
            )
        case .register:
            let urlParameters: [String: Any] = [:]
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: urlParameters
            )
            
        case .getTodos:
            let urlParameters: [String: Any] = ["select": "*","order":"time.asc"]
            return .requestParameters(
                parameters: urlParameters, 
                encoding: URLEncoding.default
            )
        case .getTodo(let todoId):
            let query = "eq." + String(todoId)
            let urlParameters: [String: Any] = ["select": "*",
                                                "todo_id":query]
            return .requestParameters(
                parameters: urlParameters,
                encoding: URLEncoding.default
            )
        case .addTodo:
            let urlParameters: [String: Any] = [:]
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: urlParameters
            )
        case .editTodo(_,_,_,_,let todoId):
            let query = "eq." + String(todoId)
            let urlParameters: [String: Any] = ["todo_id":query]
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: urlParameters
            )
        case .checkTodo(let todoId, _):
            let query = "eq." + String(todoId)
            let urlParameters: [String: Any] = ["todo_id":query]
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: urlParameters
            )
        case .deleteTodo(let todoId):
            let query = "eq." + String(todoId)
            let urlParameters: [String: Any] = ["todo_id":query]
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: urlParameters
            )
        }
    }
    
    public var validationType: ValidationType {
        switch self {
        case .login:
            return .successCodes
        default:
            return .successCodes
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
}


