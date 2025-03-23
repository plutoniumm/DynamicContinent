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
                
                if let nowPlayingMedia = notchViewModel.nowPlayingMedia {
                    Button(
                        action: {
                            guard let url = NSWorkspace.shared.urlForApplication(
                                withBundleIdentifier: nowPlayingMedia.appBundleIdentifier
                            ) else {
                                return
                            }
                            
                            NSWorkspace.shared.openApplication(
                                at: url,
                                configuration: .init()
                            )
                        }
                    ) {
                        nowPlayingMedia.appIcon
                            .resizable()
                            .scaledToFit()
                    }
                    .buttonStyle(.plain)
                    .padding(2)
                    .padding(
                        .leading,
                        notchViewModel.extraNotchPadSize.width
                    )
                    .frame(
                        height: notchViewModel.notchSize.height
                    )
                    .hide(
                        when: !mediaDefaults.isEnabled
                    )
                }
                
                OnlyNotchView(
                    notchSize: notchViewModel.notchSize
                )
                
                if let nowPlayingMedia = notchViewModel.nowPlayingMedia {
                    nowPlayingMedia.appIcon
                        .resizable()
                        .scaledToFit()
                        .opacity(0)
                        .overlay {
                            LottieView(
                                animation: MewNotch.Lotties.visualizer
                            )
                            .animationSpeed(0.2)
                            .playing(loopMode: .loop)
                            .scaledToFit()
                        }
                        .padding(5)
                        .padding(
                            .trailing,
                            notchViewModel.extraNotchPadSize.width
                        )
                        .frame(
                            height: notchViewModel.notchSize.height
                        )
                        .hide(
                            when: !mediaDefaults.isEnabled
                        )
                }
                
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
