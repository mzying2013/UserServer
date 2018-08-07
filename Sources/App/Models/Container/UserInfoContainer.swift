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
    
    //图片链接地址
    var picImageURL : String?
    
    
    init(token : String, userInfo : UserInfo) {
        self.token = token
        self.sex = userInfo.sex
        self.nickName = userInfo.nickName
        
        if let picName = userInfo.picName{
            self.picImageURL = "https://api.mzying.com/image/" + picName
        }
    }
        
}
