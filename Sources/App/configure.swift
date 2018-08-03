import Vapor
import FluentPostgreSQL
import APIErrorMiddleware

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    
    middlewares.use(ExceptionMiddleware(closure: { (req : Request) -> (EventLoopFuture<Response>?) in
        return try ResponseJSON<Empty>(status: .unknown, message: "访问路径不存在").encode(for: req)
    }))
    
    middlewares.use(APIErrorMiddleware.init(environment: env, specializations: [ModelNotFound()]))
    
    
    services.register(middlewares)
    
    
    try services.register(FluentPostgreSQLProvider())
    let pgSQL = PostgreSQLDatabaseConfig.loadSQLConfig(env)
    services.register(pgSQL)
    
    var migrations = MigrationConfig()
    migrations.add(model: LoginUser.self, database: .psql)
    migrations.add(model: AccessToken.self, database: .psql)
    migrations.add(model: RefreshToken.self, database: .psql)
    
    services.register(migrations)
    
}
