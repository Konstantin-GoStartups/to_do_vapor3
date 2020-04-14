import Vapor
import Fluent
import FluentMySQL

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Configure the rest of your application here
    // Configure MySQL db connection
    
    try services.register(FluentMySQLProvider())
    let databaseConfig = MySQLDatabaseConfig(hostname: "127.0.0.1", port: 3306, username: "vapor3", password: "vapor3", database: "todo_vapor3", transport: .unverifiedTLS)
    services.register(databaseConfig)
    
    //Configure migration
    
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Todo.self, database: DatabaseIdentifier<Todo.Database>.mysql)
    services.register(migrationConfig)
}
