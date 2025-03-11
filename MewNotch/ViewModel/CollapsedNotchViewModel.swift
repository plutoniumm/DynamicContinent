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
    
    @Published var outputAudioVolumeHUD: HUDPropertyModel?
    @Published var outputAudioDeviceHUD: HUDPropertyModel?
    
    @Published var inputAudioVolumeHUD: HUDPropertyModel?
    @Published var inputAudioDeviceHUD: HUDPropertyModel?
    
    @Published var brightnessHUD: HUDPropertyModel?
    
    @Published var powerStatusHUD: HUDPropertyModel?
    
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
        self.stopListeners()
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
    
    func resetHUDTimer(
        _ hud: inout HUDPropertyModel?,
        onComplete: @escaping () -> Void
    ) {
        hud?.timer?.invalidate()
        hud?.timer = .scheduledTimer(
            withTimeInterval: 1.0,
            repeats: false
        ) { _ in
            onComplete()
        }
    }
    
    func hideHUDs() {
        withAnimation {
            self.outputAudioVolumeHUD = nil
            self.outputAudioDeviceHUD = nil
            
            self.inputAudioVolumeHUD = nil
            self.inputAudioDeviceHUD = nil
            
            self.brightnessHUD = nil
            
            self.powerStatusHUD = nil
        }
    }
    
    func startListeners() {
        // MARK: Input Audio Change Listeners
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioInputVolumeChanges),
            name: NSNotification.Name.AudioInputVolume,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioInputDeviceChanges),
            name: NSNotification.Name.AudioInputDevice,
            object: nil
        )
        
        // MARK: Output Audio Change Listeners
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioOutputVolumeChanges),
            name: NSNotification.Name.AudioOutputVolume,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioOutputDeviceChanges),
            name: NSNotification.Name.AudioOutputDevice,
            object: nil
        )
        
        // MARK: Brightness Change Listener
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBrightnessChanges),
            name: NSNotification.Name.Brightness,
            object: nil
        )
        
        //MARK: Power Source Change Listener
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePowerStatusChanges),
            name: NSNotification.Name.PowerStatus,
            object: nil
        )
    }
    
    func stopListeners() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleAudioInputDeviceChanges() {
        if !MewDefaultsManager.shared.hudEnabled {
            return
        }
        
        withAnimation {
            self.inputAudioDeviceHUD = .init(
                lottie: nil,
                icon: MewNotch.Assets.iconSpeaker,
                name: AudioInput.sharedInstance().deviceName ?? "",
                value: 0.0,
                timer: inputAudioDeviceHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.inputAudioDeviceHUD) {
            withAnimation {
                self.inputAudioDeviceHUD = nil
            }
        }
    }
    
    @objc private func handleAudioInputVolumeChanges() {
        if !MewDefaultsManager.shared.hudEnabled {
            return
        }
        
        withAnimation {
            self.inputAudioVolumeHUD = .init(
                lottie: nil,
                icon: .init(systemName: "microphone.fill"),
                name: "Input Volume",
                value: VolumeManager.shared.getInputVolume(),
                timer: inputAudioVolumeHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.inputAudioVolumeHUD) {
            withAnimation {
                self.inputAudioVolumeHUD = nil
            }
        }
    }
    
    @objc private func handleAudioOutputDeviceChanges() {
        if !MewDefaultsManager.shared.hudEnabled {
            return
        }
        
        withAnimation {
            self.outputAudioDeviceHUD = .init(
                lottie: nil,
                icon: MewNotch.Assets.iconSpeaker,
                name: AudioOutput.sharedInstance().deviceName ?? "",
                value: 0.0,
                timer: outputAudioDeviceHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.outputAudioDeviceHUD) {
            withAnimation {
                self.outputAudioDeviceHUD = nil
            }
        }
    }
    
    @objc private func handleAudioOutputVolumeChanges() {
        if !MewDefaultsManager.shared.hudEnabled {
            return
        }
        
        withAnimation {
            self.outputAudioVolumeHUD = .init(
                lottie: MewNotch.Lotties.speaker,
                icon: MewNotch.Assets.iconSpeaker,
                name: "Output Volume",
                value: VolumeManager.shared.getOutputVolume(),
                timer: outputAudioVolumeHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.outputAudioVolumeHUD) {
            withAnimation {
                self.outputAudioVolumeHUD = nil
            }
        }
    }
    
    @objc private func handleBrightnessChanges() {
        if !MewDefaultsManager.shared.hudEnabled {
            return
        }
        
        withAnimation {
            self.brightnessHUD = .init(
                lottie: MewNotch.Lotties.brightness,
                icon: MewNotch.Assets.iconBrightness,
                name: "Brightness",
                value: Brightness.sharedInstance().brightness,
                timer: brightnessHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.brightnessHUD) {
            withAnimation {
                self.brightnessHUD = nil
            }
        }
    }
    
    @objc private func handlePowerStatusChanges() {
        if !MewDefaultsManager.shared.hudEnabled {
            return
        }
        
        
        withAnimation {
            self.powerStatusHUD = .init(
                lottie: MewNotch.Lotties.brightness,
                icon: MewNotch.Assets.iconBrightness,
                name: "Power Source",
                value: PowerStatus.sharedInstance().providingSource() == PowerStatusACPower ? 1.0 : 0.0,
                timer: powerStatusHUD?.timer
            )
        }
        
        self.resetHUDTimer(&self.powerStatusHUD) {
            withAnimation {
                self.powerStatusHUD = nil
            }
        }
    }
}
