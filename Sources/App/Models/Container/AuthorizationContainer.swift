//
//  AuthorizationContainer.swift
//  App
//
//  Created by Liu on 2018/8/2.
//

import Vapor

struct AuthorizationContainer : Content{
    var user : UserContainer
    
    var accessToken : String
    var expiresIn: String
}
