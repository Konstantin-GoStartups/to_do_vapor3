import Fluent
import FluentMySQL
import Vapor
import Foundation


final class Todo: Content, MySQLModel, Migration {
    var id: Int? = nil
    var title: String
    var text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(self, on: conn) { (builder) in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title)
            builder.field(for: \.text, type: .text())
        }
    }
}
