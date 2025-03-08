//
//  VolumeManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import AppKit

class VolumeManager {
    
    static let shared = VolumeManager()
    
    var outputAudioControl: AudioControl = .sharedInstanceOutput()
    var inputAudioControl: AudioControl = .sharedInstanceInput()
    
    private init() {}

    func isMuted() -> Bool {
        return outputAudioControl.isMute
    }

    func getOutputVolume() -> Float {
        let volume = AudioControl.sharedInstanceOutput().volume
        
        return volume.isNaN ? 0.01 : Float(volume)
    }
}
