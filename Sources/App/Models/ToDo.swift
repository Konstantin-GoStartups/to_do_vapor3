import Fluent
import FluentMySQL
import Vapor
import Foundation


struct ToDo: Content, MySQLModel, Migration {
    var id: Int? = nil
    var title: String
    var text: String
    
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(self, on: conn) { (builder) in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title)
            builder.field(for: \.text, type: .text())
        }
    }
}
