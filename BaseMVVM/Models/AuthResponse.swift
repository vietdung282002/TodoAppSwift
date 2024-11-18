//
//  LoginResponse.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 18/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import ObjectMapper

class AuthResponse: Mappable {
    var accessToken: String?
    var tokenType: String?
    var expiresIn: Int?
    var expiresAt: Int?
    var refreshToken: String?
    var user: User?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        accessToken      <- map["access_token"]
        tokenType        <- map["token_type"]
        expiresIn        <- map["expires_in"]
        expiresAt        <- map["expires_at"]
        refreshToken     <- map["refresh_token"]
        user             <- map["user"]
    }
}

