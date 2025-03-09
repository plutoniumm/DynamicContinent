//
//  CollapsedNotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

import Lottie

class CollapsedNotchViewModel: ObservableObject {
    
    @Published var notchSize: CGSize = .zero
    var extraNotchPadSize: CGSize = .init(
        width: 14,
        height: 0
    )
    
    @Published var hudIcon: LottieAnimation?
    @Published var hudValue: Float?
    
    @Published var hudTimer: Timer?
    
    init() {
        self.notchSize = NotchUtils.shared.notchSize(
            screen: NSScreen.main,
            force: MewDefaultsManager.shared.notchForceEnabled
        )
        
        withAnimation {
            notchSize.width += extraNotchPadSize.width
            notchSize.height += extraNotchPadSize.height
        }
        
        self.startListeners()
    }
    
    deinit {
        
    }
    
    func refreshNotchSize() {
        self.notchSize = NotchUtils.shared.notchSize(
            screen: NSScreen.main,
            force: MewDefaultsManager.shared.notchForceEnabled
        )
        
        withAnimation {
            notchSize.width += extraNotchPadSize.width
            notchSize.height += extraNotchPadSize.height
        }
    }
    
    func startListeners() {
        self.startListeningForVolumeChanges()
        self.startListeningForBrightnessChanges()
    }
    
    func stopListeners() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func startListeningForVolumeChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleVolumeChanges),
            name: NSNotification.Name.AudioControl,
            object: nil
        )
    }
    
    private func startListeningForBrightnessChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBrightnessChanges),
            name: NSNotification.Name.Brightness,
            object: nil
        )
    }
    
    @objc private func handleVolumeChanges() {
        if !MewDefaultsManager.shared.hudEnabled {
            return
        }
        
        withAnimation {
            hudIcon = MewNotch.Lotties.speaker
            
            if VolumeManager.shared.isMuted() {
                self.hudValue = 0.0
            } else {
                self.hudValue = VolumeManager.shared.getOutputVolume()
            }
        }
        
        hudTimer?.invalidate()
        hudTimer = .scheduledTimer(
            withTimeInterval: 1.5,
            repeats: false
        ) { _ in
            withAnimation {
                self.hudIcon = nil
                self.hudValue = nil
            }
        }
    }
    
    @objc private func handleBrightnessChanges() {
        if !MewDefaultsManager.shared.hudEnabled {
            return
        }
        
        withAnimation {
            hudIcon = MewNotch.Lotties.brightness
            
            hudValue = Float(Brightness.sharedInstance().brightness)
        }
        
        hudTimer?.invalidate()
        hudTimer = .scheduledTimer(
            withTimeInterval: 1.5,
            repeats: false
        ) { _ in
            withAnimation {
                self.hudIcon = nil
                self.hudValue = nil
            }
        }
    }
}
