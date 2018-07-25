//
//  RefreshToken.swift
//  App
//
//  Created by Liu on 2018/7/23.
//

import Crypto

struct RefreshToken: BaseSQLModel {
    
    var id : Int?
    
    static var entity : String { return self.name + "s"}
    
    typealias Token = String
    
    let tokenString : Token
    let userID : String
    
    init(userID: String) throws {
        self.tokenString = try CryptoRandom().generateData(count: 32).base64EncodedString()
        self.userID = userID
    }
    
}
