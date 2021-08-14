//
//  NetworkLogger.swift
//  NetworkModule
//
//  Created by 한상진 on 2021/08/11.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation

struct NetworkLogger {
    private enum Level: String {
        case request = "📧 REQUEST"
        case info = "💡 INFO"
        case debug = "💬 DEBUG"
        case error = "⚠️ ERROR"
        case success = "💎 SUCCESS"
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
    
    static func request(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .request, message: output)
    }
    
    static func error(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .error, message: output)
    }
    
    static func success(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .success, message: output)
    }
    
    static func info(_ items: Any...) {
        let output = toOutput(with: items)
        log(level: .info, message: output)
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
