//
//  Logger.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 04/09/2021.
//

import Foundation

struct Logger {
    
    static let shared = Logger()
    
    private (set) var logLevel: Level = .verbose
    
    enum Level {
        case verbose // All
        case error // Only errors
        case info // Only info
        case none
    }
    
    mutating func setLogLevel(_ level: Level) {
        self.logLevel = level
    }
    
    func logInfo(message: String) {
        if logLevel == .verbose || logLevel == .info {
            print(message)
        }
    }
    func logError(message: String) {
        if logLevel == .verbose || logLevel == .error {
            print(message)
        }
    }
    
}
