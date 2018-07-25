//
//  LoginUser.swift
//  App
//
//  Created by Liu on 2018/7/23.
//

import Vapor
import Authentication


struct LoginUser: BaseSQLModel {
    var id : Int?
    
    var userID : String?
    
    static var entity: String{ return self.name + "s"}
    
    private(set) var account : String
    var password: String
    
    init(userID: String, account: String, password: String) {
        self.userID = userID
        self.account = account
        self.password = password
    }
    
    static var createdAtKey: TimestampKey? = \LoginUser.createdAt
    static var updatedAtKey: TimestampKey? = \LoginUser.updatedAt
    
    var createdAt: Date?
    var updatedAt: Date?
}



extension LoginUser: BasicAuthenticatable{
    static var usernameKey: WritableKeyPath<LoginUser, String> = \.account
    static var passwordKey: WritableKeyPath<LoginUser, String> = \.password
}


extension LoginUser{
    
    func user(with digest: BCryptDigest) throws -> LoginUser {
        return try LoginUser(userID: UUID().uuidString, account: account, password: digest.hash(password))
    }
}




