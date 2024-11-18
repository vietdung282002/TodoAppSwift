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
    
    func getProfile() -> Single<User> {
        return provider.rx.request(.getProfile)
            .filterSuccessfulStatusCodes()
            .mapObject(User.self)
    }
    
    func getTodos() -> Single<Todo> {
        return provider.rx.request(.getTodos)
            .filterSuccessfulStatusCodes()
            .mapObject(Todo.self)
    }
    
    func getItems(page: Int, pageSize: Int) -> Single<ArrayResponse<Item>> {
        return provider.rx.request(.getItems(page: page, pageSize: pageSize))
            .filterSuccessfulStatusCodes()
            .mapObject(ArrayResponse<Item>.self)
    }
    
    func downloadAvatar(_ userId: String) -> Observable<Moya.ProgressResponse> {
        return provider.rx.requestWithProgress(.downloadAvatar(contentPath: ""))
    }
}
