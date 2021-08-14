//
//  DatabaseLogger.swift
//  DatabaseModule
//
//  Created by 한상진 on 2021/08/11.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation

struct DatabaseLogger {
    private enum Level: String {
        case fetch = "💡 FETCH"
        case debug = "💬 DEBUG"
        case write = "💎 WRITE"
        case delete = "❌ DELETE"
        case fatal = "🔥 FATAL"
    }
    
    private static var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    private static func log(
        level: Level,
        message: Any
    ) {
        #if DEBUG
        print("\(currentDate) \(level.rawValue) \(sourceFileName(filePath: #file)), \(#line) \(#function)")
        #endif
    }
    
    static func fetch(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .fetch, message: output)
    }
    
    static func write(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .write, message: output)
    }
    
    static func delete(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .delete, message: output)
    }
    
    static func fatal(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .fatal, message: output)
    }
    
    static func debug(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .debug, message: output)
    }
    
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        let fileName = components.last ?? ""
        return String(fileName.split(separator: ".").first ?? "")
    }
    
    private static func toOutput(with items: [Any]) -> Any {
        return items.map { String("\($0)") }.joined(separator: " ")
    }
}
