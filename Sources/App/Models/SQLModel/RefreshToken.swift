//
//  RefreshToken.swift
//  App
//
//  Created by Liu on 2018/7/23.
//

import Crypto

struct RefreshToken: BaseSQLModel {
    typealias Token = String
    
    static var entity : String { return self.name + "s"}
    
    var id : Int?
    
    let tokenString : Token
    let userID : String
    
    init(userID: String) throws {
        self.tokenString = try CryptoRandom().generateData(count: 32).base64EncodedString()
        self.userID = userID
    }
    
}
