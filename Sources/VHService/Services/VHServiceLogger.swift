//
//  VHServiceLogger.swift
//  VHService
//
//  Created by Vidal Hara on 29.04.2018.
//  Copyright © 2018 Vidal Hara. All rights reserved.
//

import UIKit

/// LogLevels for `VHServiceLogger`
///
/// - Attention:
/// 0, 10, 11, 20, 30 rawValues are allocated.
///
/// You can create different log levels
///
/// ## Usage Example: ##
///
///     let newLevel = VHServiceLoggerLevel(rawValue: 40)
///     VHServiceLogger.logLevel = [.debug, newLevel]
public struct VHServiceLoggerLevel: OptionSet {
    public let rawValue: Int

    /// Empty Log level
    static public let none = VHServiceLoggerLevel([])
    /// Log level with rawValue = 10
    static public let error = VHServiceLoggerLevel(rawValue: 10)
    /// Log level with rawValue = 11
    static public let codingError = VHServiceLoggerLevel(rawValue: 11)
    /// Log level with rawValue = 20
    static public let request = VHServiceLoggerLevel(rawValue: 20)
    /// Log level with rawValue = 30
    static public let response = VHServiceLoggerLevel(rawValue: 30)

    /// ## This level contains: ##
    ///    1. VHServiceLogLevel.none,
    ///    2. VHServiceLogLevel.error,
    ///    3. VHServiceLogLevel.request,
    ///    4. VHServiceLogLevel.response
    static public let debug: VHServiceLoggerLevel = [
        .none, .error, .request, .response
    ]

    /// ## This level contains: ##
    ///   1. VHServiceLogLevel.none,
    ///  2. VHServiceLogLevel.error
    static public let release: VHServiceLoggerLevel = [.none, .error]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

/// You can use to log needed messages
public class VHServiceLogger {

    /// `VHServiceLogger.log(...)` checks this parameter whether to log the message or not.
    public static var logLevel: VHServiceLoggerLevel = .debug

    /// You can use this to log message related to`VHServiceLogger.logLevel`
    ///
    /// # * Correct Usage Example: #
    ///
    /// ## State: ##
    ///
    /// `VHServiceLogger.logLevel` = [**VHServiceLoggerLevel.error**, VHServiceLoggerLevel.serviceRequest]
    /// ## Action: ##
    /// VHServiceLogger.log("Error message", level: **.error**)
    /// ## Result: ##
    /// Print to console time stamp and "Error message"
    ///
    /// # * Wrong Usage Example: #
    ///
    /// ## State: ##
    ///
    /// `VHServiceLogger.logLevel` = **.serviceRequest**
    /// ## Action: ##
    /// VHServiceLogger.log("Error message", level: **.error**)
    /// ## Result: ##
    /// **Nothing will print** This is because `VHServiceLogger.logLevel` not contain `VHServiceLoggerLevel.error`
    ///
    /// - Parameters:
    ///   - message: String you want to log
    ///   - level: Log Level of your message. Default value is `VHServiceLoggerLevel.debug`
    open class func log(_ message: @autoclosure () -> String, level: VHServiceLoggerLevel = VHServiceLoggerLevel.debug) {
        if logLevel.contains(level) {
            print(message())
        }
    }
}

