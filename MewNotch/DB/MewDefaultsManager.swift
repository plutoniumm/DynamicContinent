//
//  MewDefaultsManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import Foundation

class MewDefaultsManager: ObservableObject {
    
    @propertyWrapper
    public struct UserDefault<T> {
        public let key: String
        public let defaultValue: T
        public let suiteName: String?
        
        public init(_ key: String, defaultValue: T, suiteName: String? = nil) {
            self.key = key
            self.defaultValue = defaultValue
            self.suiteName = suiteName
        }
        
        public var wrappedValue: T {
            get {
                let defaults = suiteName != nil ? UserDefaults(suiteName: suiteName!) : UserDefaults.standard
                return defaults?.object(forKey: key) as? T ?? defaultValue
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
    
    enum IndicatorType {
        case compact
        case `default`
        case notched
    }
    
//    @Published
    @UserDefault(
        "BrightnessIndicatorType",
        defaultValue: IndicatorType.compact
    )
    var brightnessIndicatorType: IndicatorType
    
//    @Published
    @UserDefault(
        "VolumeIndicatorType",
        defaultValue: IndicatorType.compact
    )
    var volumeIndicatorType: IndicatorType
    
    private init() { }
}
