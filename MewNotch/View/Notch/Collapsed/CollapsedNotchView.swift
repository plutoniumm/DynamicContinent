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
    
    @StateObject var defaultsManager = MewDefaultsManager.shared
    
    var isHovered: Bool = false
    
    var body: some View {
        VStack(
            spacing: 0
        ) {
            HStack(
                spacing: 0
            ) {
                MinimalPowerHUDLeftView(
                    notchViewModel: notchViewModel,
                    hudModel: notchViewModel.powerStatusHUD
                )
                
                if defaultsManager.hudStyle == .Minimal {
                    MinimalHUDLeftView(
                        notchViewModel: notchViewModel,
                        hudModel: notchViewModel.brightnessHUD
                    )
                    
                    MinimalHUDLeftView(
                        notchViewModel: notchViewModel,
                        hudModel: notchViewModel.inputAudioVolumeHUD
                    )
                    
                    MinimalHUDLeftView(
                        notchViewModel: notchViewModel,
                        hudModel: notchViewModel.outputAudioVolumeHUD
                    )
                }
                
                if let nowPlayingMedia = notchViewModel.nowPlayingMedia {
                    nowPlayingMedia.appIcon
                        .resizable()
                        .scaledToFit()
                        .padding(2)
                        .padding(.leading, notchViewModel.extraNotchPadSize.width)
                        .frame(
                            height: notchViewModel.notchSize.height
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
                }
                
                if defaultsManager.hudStyle == .Minimal {
                    MinimalHUDRightView(
                        notchViewModel: notchViewModel,
                        hudModel: notchViewModel.outputAudioVolumeHUD
                    )
                    
                    MinimalHUDRightView(
                        notchViewModel: notchViewModel,
                        hudModel: notchViewModel.inputAudioVolumeHUD
                    )
                    
                    MinimalHUDRightView(
                        notchViewModel: notchViewModel,
                        hudModel: notchViewModel.brightnessHUD
                    )
                }
                
                MinimalPowerHUDRightView(
                    notchViewModel: notchViewModel,
                    hudModel: notchViewModel.powerStatusHUD
                )
            }
            
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
            
            if defaultsManager.hudStyle == .Progress {
                ProgressHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: notchViewModel.brightnessHUD
                )
                
                ProgressHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: notchViewModel.inputAudioVolumeHUD
                )
                
                ProgressHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: notchViewModel.outputAudioVolumeHUD
                )
            } else if defaultsManager.hudStyle == .Notched {
                NotchedHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: notchViewModel.brightnessHUD
                )
                
                NotchedHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: notchViewModel.inputAudioVolumeHUD
                )
                
                NotchedHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: notchViewModel.outputAudioVolumeHUD
                )
            }
        }
        .onReceive(
            defaultsManager.objectWillChange
        ) {
            notchViewModel.hudTimer?.invalidate()
            
            notchViewModel.hideHUDs()
            
            if defaultsManager.hudEnabled {
                OSDUIManager.shared.stop()
            } else {
                OSDUIManager.shared.start()
            }
            
            notchViewModel.refreshNotchSize()
        }
        .onAppear {
            if defaultsManager.hudEnabled {
                OSDUIManager.shared.stop()
            } else {
                OSDUIManager.shared.start()
            }
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
