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
    // MARK: - Profile
    case getProfile
    // MARK: - Item
    case getTodos
    case getItems(page: Int, pageSize: Int)
    // MARK: Upload/Download
    case uploadAvatar(data: Data)
    case downloadAvatar(contentPath: String)
}

extension ApiService: TargetType {
    
    var baseURL: URL {
        switch self {
        case .login:
            return URL(string: Configs.Network.supabaseBaseUrl)!
        case .register:
            return URL(string: Configs.Network.supabaseBaseUrl)!
        case .getTodos:
            return URL(string: Configs.Network.supabaseBaseUrl)!
        case .downloadAvatar:
            return URL(string: "https://upload.wikimedia.org")!
        case .uploadAvatar:
            return URL(string: Configs.Network.apiBaseUrl)!
        default:
            return URL(string: Configs.Network.supabaseBaseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .login( _, _):
            return "auth/v1/token"
        case .register( _, _):
            return "auth/v1/signup"
        case .getTodos:
            return "rest/v1/Todo"
        case .getItems:
            return "/3/discover/movie"
        case .getProfile:
            return "/api/user"
        case .uploadAvatar:
            return "/api/user/avatar"
        case .downloadAvatar:
            return "/wikipedia/commons/4/4e/Pleiades_large.jpg"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register:
            return .post
        case .uploadAvatar:
            return .post
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
        case .getItems(let page, let pageSize):
            params["api_key"] = Configs.Network.apiKey
            params["page"] = page
            params["pageSize"] = pageSize
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
        case .getProfile:
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        case .getTodos:
            let urlParameters: [String: Any] = ["select": "*"]
            return .requestCompositeParameters(
                bodyParameters: parameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: urlParameters
            )
        case .getItems:
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        case .uploadAvatar(let data):
            let multipartFormData = [MultipartFormData(provider: .data(data), name: "file", fileName: "image.png", mimeType: "image/png")]
            return .uploadCompositeMultipart(multipartFormData, urlParameters: ["api_key": "dc6zaTOxFJmzC", "username": "Moya"])
        case.downloadAvatar:
            return .downloadDestination(defaultDownloadDestination)
        default:
            return .requestPlain
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

// MARK: - Read file JSON for sample data


private let defaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    if !directoryURLs.isEmpty {
        let customFilename = Date().iso8601String
        guard let suggestedFilename = response.suggestedFilename else {
            fatalError("@Moya/contributor error!! We didn't anticipate this being nil")
        }
        //        return (directoryURLs[0].appendingPathComponent(suggestedFilename), [])
        return (directoryURLs[0].appendingPathComponent(customFilename), [])
    }
    
    return (temporaryURL, [])
}
