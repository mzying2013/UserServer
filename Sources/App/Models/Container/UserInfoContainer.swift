//
//  UserInfoContainer.swift
//  App
//
//  Created by Liu on 2018/8/4.
//

import Vapor


struct UserInfoContainer : Content {
    
    var token : String
    var sex : Int?
    var nickName : String?
    var picImage : File?
    
}
