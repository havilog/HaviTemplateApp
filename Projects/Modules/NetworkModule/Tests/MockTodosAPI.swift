//
//  MockTodosAPI.swift
//  NetworkModule
//
//  Created by 홍경표 on 2021/07/01.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation

import Moya

struct MockTodo: Codable, Equatable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool?
}

enum MockTodosAPI: TargetType {
    case getTodo(id: Int)
    case getTodos(id: Int? = nil, userId: Int? = nil, title: String? = nil, completed: Bool? = nil)
    case create(MockTodo)
    case updatePut(todo: MockTodo)
    case updatePatch(id: Int, title: String? = nil, completed: Bool? = nil)
    case delete(id: Int)
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com/todos")!
    }
    
    var path: String {
        switch self {
        case let .getTodo(id):
            return "\(id)"
            
        case .getTodos:
            return ""
            
        case .create:
            return ""
            
        case let .updatePut(todo):
            return "\(todo.id)"
            
        case let .updatePatch(id, _, _):
            return "\(id)"
            
        case let .delete(id):
            return "\(id)"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTodo: return .get
        case .getTodos: return .get
        case .create: return .post
        case .updatePut: return .put
        case .updatePatch: return .patch
        case .delete: return .delete
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getTodo:
            return Data(
                """
                {
                  "userId": 1,
                  "id": 3,
                  "title": "fugiat veniam minus",
                  "completed": false
                }
                """.utf8
            )
            
        case .getTodos:
            return Data(
                """
                [
                  {
                    "userId": 6,
                    "id": 105,
                    "title": "totam quia dolorem et illum repellat voluptas optio",
                    "completed": true
                  },
                  {
                    "userId": 6,
                    "id": 106,
                    "title": "ad illo quis voluptatem temporibus",
                    "completed": true
                  },
                  {
                    "userId": 6,
                    "id": 108,
                    "title": "a eos eaque nihil et exercitationem incidunt delectus",
                    "completed": true
                  },
                  {
                    "userId": 6,
                    "id": 109,
                    "title": "autem temporibus harum quisquam in culpa",
                    "completed": true
                  },
                  {
                    "userId": 6,
                    "id": 110,
                    "title": "aut aut ea corporis",
                    "completed": true
                  },
                  {
                    "userId": 6,
                    "id": 116,
                    "title": "ipsa dolores vel facilis ut",
                    "completed": true
                  }
                ]
                """.utf8
            )
            
        case .create:
            return Data(
                """
                {
                  "userId": 1,
                  "id": 201,
                  "title": "piopio"
                }
                """.utf8
            )
            
        case .updatePut:
            return Data(
                """
                {
                  "userId": 1,
                  "id": 1,
                  "title": "updated title",
                  "completed": true,
                }
                """.utf8
            )
            
        case .updatePatch:
            return Data(
                """
                {
                  "userId": 1,
                  "id": 1,
                  "title": "Final Final",
                  "completed": false,
                }
                """.utf8
            )
            
        case .delete:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getTodo:
            return .requestPlain
            
        case let .getTodos(id, userId, title, completed):
            var params: [String: Any] = [:]
            if let id = id {
                params.updateValue(id, forKey: "id")
            }
            if let userId = userId {
                params.updateValue(userId, forKey: "userId")
            }
            if let title = title {
                params.updateValue(title, forKey: "title")
            }
            if let completed = completed {
                params.updateValue(completed, forKey: "completed")
            }
            let encoding = URLEncoding(destination: .queryString, boolEncoding: .literal)
            return .requestParameters(parameters: params, encoding: encoding)
            
        case let .create(newTodo):
            var params = (try? newTodo.toDictionary()) ?? [:]
            params.removeValue(forKey: "id")
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .updatePut(todo):
            let params = (try? todo.toDictionary()) ?? [:]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .updatePatch(_, title, completed):
            var params: [String: Any] = [:]
            if let title = title {
                params.updateValue(title, forKey: "title")
            }
            if let completed = completed {
                params.updateValue(completed, forKey: "completed")
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            
        case .delete:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json; charset=UTF-8",
        ]
    }
    
}

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
