//
//  ResponseJSON.swift
//  App
//
//  Created by Liu on 2018/7/24.
//

import Vapor

struct Empty : Content{
    
}



struct ResponseJSON<T: Content> : Content {
    
    private var status : ResponseStatus
    private var message : String
    private var data : T?
    
    
    init(status: ResponseStatus = .ok,
         message: String? = nil,
         data:T? = nil) {
        self.status = status
        self.message = message ?? status.desc        
        self.data = data
    }
}




enum ResponseStatus : Int, Content{
    case ok = 0
    case error = 1
    case missesPara = 3
    case token = 4
    case unknown = 10
    case userExist = 20
    case userNotExist = 21
    case passwordError = 22
    
    var desc : String{
        switch self {
        case .ok:
            return "请求成功"
            
        case .error:
            return "请求失败"
            
        case .missesPara:
            return "缺少参数"
            
        case .token:
            return "Token 已失效，请重新登录"
            
        case .unknown:
            return "未知错误"
            
        case .userExist:
            return "用户已存在"
            
        case .userNotExist:
            return "用户不存在"
            
        case .passwordError:
            return  "密码不正确"
            
        }
    }
}
