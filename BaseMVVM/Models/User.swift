//
//  User.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 1/5/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var id: String?
    var aud: String?
    var role: String?
    var email: String?
    var emailConfirmedAt: String?
    var phone: String?
    var confirmedAt: String?
    var lastSignInAt: String?
    var appMetadata: AppMetadata?
    var userMetadata: [String: Any]?
    var identities: [Identity]?
    var createdAt: String?
    var updatedAt: String?
    var isAnonymous: Bool?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id                  <- map["id"]
        aud                 <- map["aud"]
        role                <- map["role"]
        email               <- map["email"]
        emailConfirmedAt    <- map["email_confirmed_at"]
        phone               <- map["phone"]
        confirmedAt         <- map["confirmed_at"]
        lastSignInAt        <- map["last_sign_in_at"]
        appMetadata         <- map["app_metadata"]
        userMetadata        <- map["user_metadata"]
        identities          <- map["identities"]
        createdAt           <- map["created_at"]
        updatedAt           <- map["updated_at"]
        isAnonymous         <- map["is_anonymous"]
    }
    func printUserInfo() {
        print("User ID: \(id ?? "N/A")")
        print("Email: \(email ?? "N/A")")
        print("Role: \(role ?? "N/A")")
        print("Phone: \(phone ?? "N/A")")
        print("Confirmed At: \(confirmedAt ?? "N/A")")
        print("Last Sign In At: \(lastSignInAt ?? "N/A")")
        print("Created At: \(createdAt ?? "N/A")")
        print("Updated At: \(updatedAt ?? "N/A")")
        print("Is Anonymous: \(isAnonymous ?? false)")
        
        // In thông tin metadata
        if let appMetadata = appMetadata {
            print("App Provider: \(appMetadata.provider ?? "N/A")")
            print("App Providers: \(appMetadata.providers?.joined(separator: ", ") ?? "N/A")")
        }
        
        // In thông tin identities
        if let identities = identities {
            for identity in identities {
                print("Identity ID: \(identity.identityId ?? "N/A")")
                print("Identity Email: \(identity.email ?? "N/A")")
                print("Last Sign In: \(identity.lastSignInAt ?? "N/A")")
            }
        }
    }
}

class AppMetadata: Mappable {
    var provider: String?
    var providers: [String]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        provider    <- map["provider"]
        providers   <- map["providers"]
    }
}

class Identity: Mappable {
    var identityId: String?
    var id: String?
    var userId: String?
    var identityData: IdentityData?
    var provider: String?
    var lastSignInAt: String?
    var createdAt: String?
    var updatedAt: String?
    var email: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        identityId      <- map["identity_id"]
        id              <- map["id"]
        userId          <- map["user_id"]
        identityData    <- map["identity_data"]
        provider        <- map["provider"]
        lastSignInAt    <- map["last_sign_in_at"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
        email           <- map["email"]
    }
}

class IdentityData: Mappable {
    var email: String?
    var emailVerified: Bool?
    var phoneVerified: Bool?
    var sub: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email               <- map["email"]
        emailVerified       <- map["email_verified"]
        phoneVerified       <- map["phone_verified"]
        sub                 <- map["sub"]
    }
}
