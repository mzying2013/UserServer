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
        
        let rootGroup = router.grouped("app")
        let userGroup = "user"
        
        rootGroup.post(LoginUser.self, at: userGroup, use: registerUserHandler)
        rootGroup.get(userGroup, use: allUserHandler)
        
        //Login
        rootGroup.post(LoginUser.self, at: userGroup,"authorization", use: loginUserHandler)
        //Exit
        rootGroup.delete(userGroup,"authorization", use: exitUserHandler)
        
    }
}


extension UserRouterController{
    
    func allUserHandler(_ req: Request) -> Future<Response> {
        let query = LoginUser.query(on: req)
        
        return query.all().flatMap {users in
            
            let userContainer = users.map({ (user: LoginUser) -> UserContainer in
                return UserContainer(userID: user.id!, account: user.account, password: user.password)
            })
            
            return try ResponseJSON<[UserContainer]>(status: .ok, message: nil, data: userContainer).encode(for: req)
        }
    }
    
    
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
    
    
    
    //根据账户名搜索
    //查看搜索结果
    //校验密码
    //生成AccessToken & RefreshToken
    //转换为 AccessContainer 结构体
    
    
    func loginUserHandler(_ req: Request, lu : LoginUser) throws -> Future<Response> {
        
        let first = LoginUser.query(on: req).filter(\.account == lu.account).first()
        
        return first.flatMap({ (eu : LoginUser?) -> Future<Response> in
            
            guard let existingUser = eu else{
                return try ResponseJSON<Empty>(status: .userNotExist).encode(for: req)
            }
            
            
            let digest = try req.make(BCryptDigest.self)
            guard try digest.verify(lu.password, created: existingUser.password) else{
                return try ResponseJSON<Empty>(status: .passwordError).encode(for: req)
            }
            
            
            let accessAndRefreshToken = try self.authController.authContainer(for: existingUser, on: req)
            
            return accessAndRefreshToken.flatMap({ (ac : AuthContainer) -> Future<Response> in
                
                let accessCon = AccessContainer(accessToken: ac.accessToken, userID: existingUser.userID)
                
                return try ResponseJSON<AccessContainer>(status: .ok, message: "登录成功", data: accessCon).encode(for: req)
            })
        })
        
    }
    
    
    
    
    
    func exitUserHandler(_ req : Request) throws -> Future<Response> {
        //获取参数
        return try req.content.decode(AccessContainer.self).flatMap({ (ac : AccessContainer) -> Future<Response> in
            //转换为 BearerAuthorization 结构体
            let bearToken = BearerAuthorization(token: ac.accessToken)
            
            //查找 accessToken
            return AccessToken.authenticate(using: bearToken, on: req).flatMap({ (at : AccessToken?) -> Future<Response> in
                guard let existingToken = at else{
                    //没有找到 accessToken
                    return try ResponseJSON<Empty>(status: .token).encode(for: req)
                }
                
                //找到 accessToken
                return try self.authController.remokeTokens(userID: existingToken.userID, on: req).flatMap({_ -> Future<Response> in
                    return try ResponseJSON<Empty>(status: .ok, message: "退出登录成功").encode(for: req)
                })
            })
            
        })
        
    }
    
    
    
}



