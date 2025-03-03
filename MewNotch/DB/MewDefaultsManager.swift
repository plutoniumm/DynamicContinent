//
//  MewDefaultsManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

class MewDefaultsManager: ObservableObject {
    
    @propertyWrapper
    public struct CodableUserDefault<T> where T: Codable {
        
        let key: String
        let defaultValue: T
        let suiteName: String?
        
        public init(
            _ key: String,
            defaultValue: T,
            suiteName: String? = nil
        ) {
            self.key = key
            self.defaultValue = defaultValue
            self.suiteName = suiteName
        }
        
        public var wrappedValue: T {
            get {
                let defaults = suiteName != nil ? UserDefaults(
                    suiteName: suiteName!
                ): UserDefaults.standard
                
                guard let data = defaults?.data(forKey: key) else {
                    return defaultValue
                }
                
                return (
                    try? JSONDecoder().decode(T.self, from: data)
                ) ?? defaultValue
            }
            set {
                let defaults = suiteName != nil ? UserDefaults(
                    suiteName: suiteName!
                ): UserDefaults.standard
                
                let encoded = try? JSONEncoder().encode(newValue)
                
                defaults?.set(encoded, forKey: key)
            }
        }
    }
    
    @propertyWrapper
    public struct UserDefault<T> {
        public let key: String
        public let defaultValue: T
        public let suiteName: String?
        
        public init(
            _ key: String,
            defaultValue: T,
            suiteName: String? = nil
        ) {
            self.key = key
            self.defaultValue = defaultValue
            self.suiteName = suiteName
        }
        
        public var wrappedValue: T {
            get {
                let defaults = suiteName != nil ? UserDefaults(
                    suiteName: suiteName!
                ): UserDefaults.standard
                
                return defaults?.object(
                    forKey: key
                ) as? T ?? defaultValue
            }
            set {
                let defaults = suiteName != nil ? UserDefaults(suiteName: suiteName!) : UserDefaults.standard
                defaults?.set(newValue, forKey: key)
            }
        }
    }
    
    static let shared = MewDefaultsManager()
    
    private let userDefaults: UserDefaults = .standard
    
    // MARK: Enums
    public enum NotchHeightMode: String, CaseIterable, Identifiable, Codable {
        var id: String { rawValue }
        
        case Match_Notch
        case Match_Menu_Bar
        case Manual
    }
    
    public enum HUDStyle: String, CaseIterable, Identifiable, Codable {
        var id: String { rawValue }
        
        case Minimal
        case Progress
        case Notched
    }
    
    
    // MARK: Variables
    
    @UserDefault(
        "MenuIconShown",
        defaultValue: true
    )
    var showMenuIcon: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @UserDefault(
        "NotchForceEnabled",
        defaultValue: false
    )
    var notchForceEnabled: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @CodableUserDefault(
        "NotchHeightMode",
        defaultValue: NotchHeightMode.Match_Notch
    )
    var notchHeightMode: NotchHeightMode {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @UserDefault(
        "HUDEnabled",
        defaultValue: true
    )
    var hudEnabled: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @CodableUserDefault(
        "HUDStyle",
        defaultValue: HUDStyle.Minimal
    )
    var hudStyle: HUDStyle {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    private init() { }
}
