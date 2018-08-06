//
//  UserInfo.swift
//  App
//
//  Created by Liu on 2018/8/4.
//



struct UserInfo : BaseSQLModel {
    
    var id  : Int?
    
    static var entity : String { return self.name + "s"}
    
    var userID: String
    
    var sex : Int?
    var nickName : String?
    var picName : String?
    
}


extension UserInfo{
    
    mutating func update(with container: UserInfoContainer) -> UserInfo{
        
        if let new = container.sex{
            self.sex = new
        }        
        
        if let new = container.nickName {
            self.nickName = new
        }
        
        return self;
    }
    
}
