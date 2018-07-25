//
//  SQLConfig.swift
//  App
//
//  Created by Liu on 2018/7/25.
//

import Vapor
import FluentPostgreSQL

extension PostgreSQLDatabaseConfig{
    
    static func loadSQLConfig(_ env: Environment) -> PostgreSQLDatabaseConfig{
        
        let database = env.isRelease ? "vaporDB" : "vaporDebugDB"
        
        let hostname = "149.28.233.76"
        let username = "vapor"
        let password = "Vapor_Postgres_DB"
        let port = 4406
        
        return PostgreSQLDatabaseConfig(hostname: hostname,
                                        port: port,
                                        username: username,
                                        database: database,
                                        password: password)
    }
    
}
