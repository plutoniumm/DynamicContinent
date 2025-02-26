//
//  VolumeManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import AppKit

class VolumeManager {
    
    static let shared = VolumeManager()
    
    private init() {}

    func isMuted() -> Bool {
        do {
            return try AppleScriptRunner.shared.run(
                script: "return output muted of (get volume settings)"
            ) == "true"
        } catch {
            NSLog(
                "Error while trying to retrieve muted properties of device: \(error). Returning default value false."
            )
            
            return false
        }
    }

    func getOutputVolume() -> Float {
        do {
            if let volumeStr = Float(
                try AppleScriptRunner.shared.run(
                    script: "return output volume of (get volume settings)"
                )
            ) {
                return volumeStr / 100
            } else {
                NSLog(
                    "Error while trying to parse volume string value. Returning default volume value 1."
                )
            }
        } catch {
            NSLog(
                "Error while trying to retrieve volume properties of device: \(error). Returning default volume value 1."
            )
        }
        
        return 0.01
    }
}
