//
//  AuthContainer.swift
//  App
//
//  Created by Liu on 2018/7/23.
//

import Vapor

struct AuthContainer : Content {
    
    let accessToken: AccessToken.Token
    let expiresIn: TimeInterval
    let refreshToken: RefreshToken.Token
    
    init(accessToken: AccessToken, refreshToken: RefreshToken) {
        self.accessToken = accessToken.tokenString
        self.expiresIn = AccessToken.accessTokenExpirationInterval
        self.refreshToken = refreshToken.tokenString
    }
    
}


struct RefreshTokenContainer: Content {
    let refreshToken : RefreshToken.Token
}
