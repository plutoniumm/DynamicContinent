//
//  NotchDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

class NotchDefaults: ObservableObject {
    
    private static var PREFIX: String = "Notch_"
    
    static let shared = NotchDefaults()
    
    private init() {}
    
    @PrimitiveUserDefault(
        PREFIX + "ForceEnabled",
        defaultValue: false
    )
    var forceEnabled: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @CodableUserDefault(
        PREFIX + "HeightMode",
        defaultValue: NotchHeightMode.Match_Notch
    )
    var heightMode: NotchHeightMode {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PrimitiveUserDefault(
        PREFIX + "ExpandOnHover",
        defaultValue: false
    )
    var expandOnHover: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
}
