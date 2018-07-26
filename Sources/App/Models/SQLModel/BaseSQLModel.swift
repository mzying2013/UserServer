//
//  BaseSQLModel.swift
//  App
//
//  Created by Liu on 2018/7/23.
//

import Vapor
import FluentPostgreSQL
import Authentication

public typealias BaseSQLModel = PostgreSQLModel & Migration & Content

//protocol SuperModel : BaseSQLModel {
//    static var entity : String {get}
//
//    static var createdAtKey: TimestampKey? {get}
//    static var updatedAtKey: TimestampKey? {get}
//    static var deletedAtKey: TimestampKey? {get}
//
//    var createdAt: Date? {get set}
//    var updatedAt: Date? {get set}
//    var deletedAt: Date? {get set}
//}
//
//
//extension SuperModel{
//
//    var deletedAt: Date? {return nil}
//
//    static var entity: String { return self.name + "s"}
//
//    static var createdAtKey : TimestampKey? { return \Self.createdAt}
//    static var updatedAtKey: TimestampKey? { return \Self.updatedAt}
//    static var deletedAtKey: TimestampKey? { return \Self.deletedAt}
//
//}

