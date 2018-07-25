//
//  String+Extension.swift
//  App
//
//  Created by Liu on 2018/7/25.
//

import Foundation


extension String{
    
    func isAccount() -> (valid: Bool, msg: String) {
        if count < kAccountMinCount {
            return (false,"账号长度少于\(kAccountMinCount)位")
        }
        
        if count > kAccountMaxCount {
            return (false,"账号长度超过\(kAccountMaxCount)位")
        }
        
        return (true,"账号符合")
    }
    
    
    func isPassword() -> (valid: Bool, msg: String) {
        if count < kPasswordMinCount {
            return (false,"密码长度少于\(kPasswordMinCount)位")
        }
        
        if count > kPasswordMaxCount {
            return (false,"密码长度超过\(kPasswordMaxCount)位")
        }
        
        return (true,"密码符合")
    }
    
}
