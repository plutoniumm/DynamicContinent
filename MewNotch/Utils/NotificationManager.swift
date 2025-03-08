//
//  NotificationManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import Foundation

class NotificationManager {
    
    static let brightnessChangedNotification = Notification.Name("MewNotch.brightnessChangedNotification")
    static let backlightChangedNotification = Notification.Name("MewNotch.backlightChangedNotification")
    
    static let shared = NotificationManager()
    
    private init() { }
    
    func postBrightnessChanged() {
        NotificationCenter.default.post(
            name: Self.brightnessChangedNotification,
            object: self
        )
    }
    
    func postBacklightChanged() {
        NotificationCenter.default.post(
            name: Self.backlightChangedNotification,
            object: self
        )
    }
}
