//
//  CollapsedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

import Lottie

struct CollapsedNotchView: View {
    
    @ObservedObject var notchViewModel: CollapsedNotchViewModel
    
    @StateObject var notchDefaults = NotchDefaults.shared
    
    @StateObject var mediaDefaults = HUDMediaDefaults.shared
    
    var isHovered: Bool = false
    
    var body: some View {
        VStack(
            spacing: 0
        ) {
            HStack(
                spacing: 0
            ) {
                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: notchViewModel.brightnessHUD
                )
                
                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: notchViewModel.inputAudioVolumeHUD
                )
                
                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: notchViewModel.outputAudioVolumeHUD
                )
                
                NowPlayingHUDLeftView(
                    notchViewModel: notchViewModel
                )
                .hide(
                    when: !mediaDefaults.isEnabled
                )
                
                OnlyNotchView(
                    notchSize: notchViewModel.notchSize
                )
                
                NowPlayingHUDRightView(
                    notchViewModel: notchViewModel
                )
                .hide(
                    when: !mediaDefaults.isEnabled
                )
                
                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: notchViewModel.outputAudioVolumeHUD
                )
                
                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: notchViewModel.inputAudioVolumeHUD
                )
                
                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: notchViewModel.brightnessHUD
                )
            }
            
            PowerHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDPowerDefaults.shared,
                hudModel: notchViewModel.powerStatusHUD
            )
            
            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .Input,
                hudModel: notchViewModel.inputAudioDeviceHUD
            )
            
            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .Output,
                hudModel: notchViewModel.outputAudioDeviceHUD
            )
            
            // MARK: Progress Style Views
            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDBrightnessDefaults.shared,
                hudModel: notchViewModel.brightnessHUD
            )
            
            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: notchViewModel.inputAudioVolumeHUD
            )
            
            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: notchViewModel.outputAudioVolumeHUD
            )
            
            // MARK: Notched Style View
            
            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDBrightnessDefaults.shared,
                hudModel: notchViewModel.brightnessHUD
            )
            
            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: notchViewModel.inputAudioVolumeHUD
            )
            
            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: notchViewModel.outputAudioVolumeHUD
            )
        }
        .onReceive(
            notchDefaults.objectWillChange
        ) {
            notchViewModel.hideHUDs()
            
//            if defaultsManager.hudEnabled {
//                OSDUIManager.shared.stop()
//            } else {
//                OSDUIManager.shared.start()
//            }
            
            notchViewModel.refreshNotchSize()
        }
        .onAppear {
//            if defaultsManager.hudEnabled {
//                OSDUIManager.shared.stop()
//            } else {
//                OSDUIManager.shared.start()
//            }
        }
    }
}

#Preview {
    CollapsedNotchView(
        notchViewModel: .init(
            screen: .main!
        )
    )
}
