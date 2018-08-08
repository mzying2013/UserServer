import Vapor

/// Creates an instance of Application. This is called from main.swift in the run target.
public func app(_ env: Environment) throws -> Application {
    var config = Config.default()
    
    var env = env
//    var arguments = CommandLine.arguments
//    arguments.append(contentsOf: ["--hostname","127.0.0.1","--port","8066"])
//    let commandInput = CommandInput(arguments: arguments)
//    env.commandInput = commandInput    
    
    var services = Services.default()
    try configure(&config, &env, &services)
    let app = try Application(config: config, environment: env, services: services)
    try boot(app)
    return app
}
