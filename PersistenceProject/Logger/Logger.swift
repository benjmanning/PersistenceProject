//
//  Logger.swift
//  PersistenceProject
//
//  Created by Ben Manning on 29/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import Foundation
import os.log

class Logger {
  
  static let shared = Logger()
  
  enum Level {
    case error
    case warning
    case info
    case debug
  }
  
  func log(level: Level, message: String, file: String) {
    if level != .debug {
      let filename = extractFilenameWithoutExtension(file)
      log(level: level, line: "[\(filename)] - \(message)")
    }
  }
  
  func log(level: Level, line: String) {
    os_log("%s", log: OSLog.default, type: osLogType(from: level), line)
  }
  
  func osLogType(from level: Level) -> OSLogType {
    switch level {
    case .error: return .fault
    case .warning: return .error
    case .info: return .info
    case .debug: return .debug
    }
  }
  
  private func extractFilenameWithoutExtension(_ filename: String) -> String {
    return ((filename as NSString).lastPathComponent as NSString).deletingPathExtension
  }
  
  static func e(_ message: String, file: String = #file) {
    shared.log(level: .error, message: message, file: file)
  }
  
  static func w(_ message: String, file: String = #file) {
    shared.log(level: .warning, message: message, file: file)
  }
  
  static func i(_ message: String, file: String = #file) {
    shared.log(level: .info, message: message, file: file)
  }
  
  static func d(_ message: String, file: String = #file) {
    shared.log(level: .debug, message: message, file: file)
  }
}
