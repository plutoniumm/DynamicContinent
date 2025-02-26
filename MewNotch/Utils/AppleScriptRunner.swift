//
//  AppleScriptRunner.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import Foundation

class AppleScriptRunner {
    
    enum AppleScriptError: Error {
        case initScriptFailed
        case runtimeError
        case emptyOutput
    }
    
    static let shared = AppleScriptRunner()
    
    private init() {}

    func run(
        script: String
    ) throws -> String {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(
            source: script
        ) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                &error
            )
            
            guard error == nil else {
                throw AppleScriptError.runtimeError
            }
            
            if let outputString = output.stringValue {
                return outputString
            }
            
            throw AppleScriptError.emptyOutput
        }
        
        throw AppleScriptError.initScriptFailed
    }
}
