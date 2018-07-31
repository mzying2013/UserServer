//
//  UserRouteController.swift
//  App
//
//  Created by Liu on 2018/7/23.
//

import Vapor

import Crypto
import Authentication


final class UserRouterController : RouteCollection{
    private let authController = AuthController()
    
    func boot(router: Router) throws {
        
        let group = router.grouped("user")
        
        group.post(LoginUser.self, use: registerUserHandler)
    }
}


extension UserRouterController{
    
    //MARK: 注册
    func registerUserHandler(_ req: Request, newUser: LoginUser) throws -> Future<Response> {
        //查询同名 account
        let futureFirst = LoginUser.query(on: req).filter(\.account == newUser.account).first()

        return futureFirst.flatMap({existingUser in
            //判断用户是否存在
            guard existingUser == nil else{
                return try ResponseJSON<Empty>(status: .userExist).encode(for: req)
            }
            
            //获取账号格式校验
            let isAccount = newUser.account.isAccount()
            
            if !isAccount.valid{
                return try ResponseJSON<Empty>(status: .error,message: isAccount.msg).encode(for: req)
            }
            
            
            //获取密码格式校验
            let isPassword = newUser.password.isPassword()
            
            if  !isPassword.valid{
                return try ResponseJSON<Empty>(status: .error, message: isPassword.msg).encode(for: req)
            }
            
            //创建新用户
            //为提供的类型创建服务
            let digst = try req.make(BCryptDigest.self)
            //创建用户
            let user = try newUser.user(with: digst)
            
            //写入数据库
            return user.save(on: req).flatMap({ user in
                
                return try self.authController.authContainer(for: user, on: req).flatMap({ container in
                    //需要返回的Data数据
                    var access = AccessContainer(accessToken: container.accessToken)
                    
                    //如果开发环境，不需要返回userID。只需要accessToken即可。
                    if !req.environment.isRelease{
                        access.userID = user.userID
                    }
                    
                    return try ResponseJSON<AccessContainer>(status: .ok, message: "注册成功", data: access).encode(for: req)
                })
            })
            
        })
        
    }
}



