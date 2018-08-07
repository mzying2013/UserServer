//
//  File+Extension.swift
//  App
//
//  Created by Liu on 2018/8/6.
//

import Vapor



extension File{
    var uniqueFileName : String{
        
        let unique = UUID().uuidString
        
        guard let ext = ext else{
            return unique
        }
        
        return unique + "." + ext
    }
}
