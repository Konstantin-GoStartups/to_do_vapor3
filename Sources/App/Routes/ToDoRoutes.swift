import Vapor
import Fluent
import FluentMySQL
import Foundation

class ToDoRoutes: RouteCollection {
    func boot(router: Router) throws {
        router.group("backend") { group in
            group.get("todos", use: fetchToDos)
            group.get("todo", Int.parameter, use: fetchToDo)
            group.post("todo", use: createToDo)
            group.post("todo","delete", Int.parameter, use: deleteTodo)
        }
    }
    
    func fetchToDos(on req: Request) throws -> Future<[ToDo]> {
        return ToDo.query(on: req).sort(\ToDo.id,.ascending).all()
    }
    
    func fetchToDo(on req: Request) throws -> Future<ToDo> {
        let id = try req.parameters.next(Int.self)
        
        return ToDo.find(id,on: req).map(to: ToDo.self) { todo in
            guard let todo = todo else {
                throw Abort(.notFound)
            }
            return todo
        }
    }
    
    func createToDo(on req: Request) throws -> EventLoopFuture<ToDo> {
        let title: String = try req.content.syncGet(at: "title")
        let text: String = try req.content.syncGet(at: "text")
        let todo = ToDo(title: title, text: text)
        return todo.save(on: req)
    }
    
    func deleteTodo(on req: Request) throws -> EventLoopFuture<Response> {
        let id = try req.parameters.next(Int.self)
        return ToDo.query(on: req).filter(\.id == id).delete().map(to: Response.self) {
            return req.redirect(to: "/backend/todos")
        }
    }
    
}
