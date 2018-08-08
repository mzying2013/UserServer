import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    //更新 Services
    var nioServerConfig = NIOServerConfig.default()
    nioServerConfig.maxBodySize = 4 * 1024 * 1024
    services.register(nioServerConfig)
//    services.register(NIOServerConfig.self)
    
    
    /// Register providers first
    

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    
    // Catches errors and converts to HTTP response
    middlewares.use(ErrorMiddleware.self)
    
    //Vapor middleware for converting thrown errors to JSON responses
    //无用，只能返回 message，且结构不能改变
    //middlewares.use(APIErrorMiddleware(environment: env, specializations: [ModelNotFound()]))
    
    middlewares.use(ExceptionMiddleware(closure: { (req : Request) -> (EventLoopFuture<Response>?) in
        return try ResponseJSON<Empty>(status: .unknown, message: "访问路径不存在").encode(for: req)
    }))
    
    
    services.register(middlewares)
    
    
    try services.register(FluentPostgreSQLProvider())
    let pgSQL = PostgreSQLDatabaseConfig.loadSQLConfig(env)
    services.register(pgSQL)
    
    var migrations = MigrationConfig()
    migrations.add(model: LoginUser.self, database: .psql)
    migrations.add(model: AccessToken.self, database: .psql)
    migrations.add(model: RefreshToken.self, database: .psql)
    migrations.add(model: UserInfo.self, database: .psql)
    
    services.register(migrations)
    
}


