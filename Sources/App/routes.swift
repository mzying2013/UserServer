import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("version") {req in
        return req.description
    }

    // Example of configuring a controller
    let grouped = router.grouped("app")
    try grouped.register(collection: UserRouterController())
    
}
