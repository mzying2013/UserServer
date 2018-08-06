//
//  File+Extension.swift
//  App
//
//  Created by Liu on 2018/8/6.
//

import Vapor


extension File{
    var uniqueFileName : String{
        var uniqueFileName = filename
        let index = uniqueFileName.index(of: ".")
        
        guard let foundIndex = index else{
            return uniqueFileName + UUID().uuidString
        }
        
        uniqueFileName.insert(contentsOf: UUID().uuidString, at: foundIndex)
        
        return uniqueFileName
    }
}
