//
//  HUDAudioInputDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

class HUDAudioInputDefaults: HUDDefaultsProtocol {
    
    internal static var PREFIX: String = "HUD_Audio_Input_"
    
    static let shared = HUDAudioInputDefaults()
    
    private init() {}
    
    @PrimitiveUserDefault(
        PREFIX + "Enabled",
        defaultValue: true
    )
    var isEnabled: Bool {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
    
    @CodableUserDefault(
        PREFIX + "Style",
        defaultValue: HUDStyle.Minimal
    )
    var style: HUDStyle {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
}

