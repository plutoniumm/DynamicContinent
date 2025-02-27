//
//  MewDefaultsManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

class MewDefaultsManager: ObservableObject {
    
    @propertyWrapper
    public struct RawEnumUserDefault<T> where T: RawRepresentable {
        
        let key: String
        let defaultValue: T
        let suiteName: String?
        
        let initializer: (T.RawValue) -> T?
        
        public init(
            _ key: String,
            defaultValue: T,
            suiteName: String? = nil,
            initializer: @escaping (T.RawValue) -> T?
        ) {
            self.key = key
            self.defaultValue = defaultValue
            self.suiteName = suiteName
            
            self.initializer = initializer
        }
        
        public var wrappedValue: T {
            get {
                let defaults = suiteName != nil ? UserDefaults(
                    suiteName: suiteName!
                ): UserDefaults.standard
                
                return self.initializer(
                    defaults?.object(
                        forKey: key
                    ) as? T.RawValue ?? defaultValue.rawValue
                ) ?? defaultValue
            }
            set {
                let defaults = suiteName != nil ? UserDefaults(
                    suiteName: suiteName!
                ): UserDefaults.standard
                
                defaults?.set(
                    newValue.rawValue,
                    forKey: key
                )
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
    
    // MARK: Variables
    
    enum HUDType: String, CaseIterable, Identifiable, Codable {
        var id: String { rawValue }
        
        case minimal
        case progress
        case system
        case notched
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
    
    @RawEnumUserDefault(
        "HUDType",
        defaultValue: HUDType.minimal,
        initializer: {
            return HUDType.init(
                rawValue: $0
            )
        }
    )
    var hudType: HUDType {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    private init() { }
}
