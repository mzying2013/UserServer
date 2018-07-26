//
//  AccessContainer.swift
//  App
//
//  Created by Liu on 2018/7/26.
//

import Vapor

struct AccessContainer: Content {
    
    var accessToken: String
    var userID: String?
    
    init(accessToken: String, userID: String? = nil){
        self.accessToken = accessToken
        self.userID = userID
    }
    
}
