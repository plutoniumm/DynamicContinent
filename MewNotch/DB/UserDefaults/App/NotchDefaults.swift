//
//  NotchDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

class NotchDefaults: ObservableObject {
    
    enum ExpandedNotchItems: String, CaseIterable, Codable, Identifiable {
        var id: String {
            self.rawValue
        }
        
        case Mirror
        case NowPlaying
        
        func displayName() -> String {
            switch self {
            case .Mirror:
                return "Mirror"
            case .NowPlaying:
                return "Now Playing"
            }
        }
    }
    
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
    
    @PrimitiveUserDefault(
        PREFIX + "ExpandedNotchShowDividers",
        defaultValue: true
    )
    var showDividers: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @CodableUserDefault(
        PREFIX + "ExpandedNotchItems",
        defaultValue: [
            ExpandedNotchItems.Mirror
        ]
    )
    var expandedNotchItems: Set<ExpandedNotchItems> {
        didSet {
            self.objectWillChange.send()
        }
    }
}
