//
//  Log.swift
//  UtilityModule
//
//  Created by 홍경표 on 2021/08/05.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation

public struct Logger {
    
    private init() {}
    
    private enum Level: String {
        case debug = "💬 DEBUG"
        case info  = "💡 INFO"
        case error = "⚠️ ERROR"
        case fatal = "🔥 FATAL"
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    private static var currentDateString: String {
        return dateFormatter.string(from: Date())
    }
    
    private static func log(
        level: Level,
        _ output: Any,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        separator: String = " "
    ) {
        #if DEBUG
        let pretty = "\(currentDateString) \(level.rawValue) \(sourceFileName(filePath: fileName)):#\(line) \(function) ->"
        print(pretty, output)
        #endif
    }
    
    public static func debug(
        _ items: Any...,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        separator: String = " "
    ) {
        let output = toOutput(with: items)
        log(level: .debug, output, fileName: fileName, function: function, line: line, separator: separator)
    }
    
    public static func info(
        _ items: Any...,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        separator: String = " "
    ) {
        let output = toOutput(with: items)
        log(level: .info, output, fileName: fileName, function: function, line: line, separator: separator)
    }
    
    public static func error(
        _ items: Any...,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        separator: String = " "
    ) {
        let output = toOutput(with: items)
        log(level: .error, output, fileName: fileName, function: function, line: line, separator: separator)
    }
    
    public static func fatal(
        _ items: Any...,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        separator: String = " "
    ) {
        let output = toOutput(with: items)
        log(level: .fatal, output, fileName: fileName, function: function, line: line, separator: separator)
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
