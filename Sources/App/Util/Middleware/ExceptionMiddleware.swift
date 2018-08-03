//
//  ExceptionMiddleware.swift
//  App
//
//  Created by Liu on 2018/8/3.
//

import Vapor

public final class ExceptionMiddleware : Middleware, Service{
    
    typealias ExceptionClosure = (Request) throws -> (Future<Response>?)
    private let closure : ExceptionClosure
    
    init(closure: @escaping ExceptionClosure) {
        self.closure = closure
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        return try next.respond(to: request).flatMap({ (resp : Response) -> Future<Response> in
                        
            let status = resp.http.status

            if status == .notFound{
                if let resp = try self.closure(request){
                    return resp
                }
            }
            
            return request.eventLoop.newSucceededFuture(result: resp)
            
        })
    }
}
