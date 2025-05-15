//
//  HUDPowerDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

class HUDPowerDefaults: HUDDefaultsProtocol {
    
    internal static var PREFIX: String = "HUD_Power_"
    
    static let shared = HUDPowerDefaults()
    
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
        defaultValue: HUDStyle.Progress
    )
    var style: HUDStyle {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
}
