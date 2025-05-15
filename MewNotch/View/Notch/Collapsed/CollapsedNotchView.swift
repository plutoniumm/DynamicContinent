//
//  CollapsedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

import Lottie

struct CollapsedNotchView: View {
    @ObservedObject var notchViewModel: NotchViewModel

    @StateObject var collapsedNotchViewModel: CollapsedNotchViewModel = .init()

    @StateObject var notchDefaults = NotchDefaults.shared

    @StateObject var mediaDefaults = HUDMediaDefaults.shared

    var body: some View {
        VStack( spacing: 0 ) {
            HStack( spacing: 0 ) {
                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: collapsedNotchViewModel.brightnessHUD
                )

                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
                )

                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
                )

                OnlyNotchView( notchSize: notchViewModel.notchSize )

                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
                )

                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
                )

                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: collapsedNotchViewModel.brightnessHUD
                )
            }

            PowerHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDPowerDefaults.shared,
                hudModel: collapsedNotchViewModel.powerStatusHUD
            )

            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .Input,
                hudModel: collapsedNotchViewModel.inputAudioDeviceHUD
            )

            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .Output,
                hudModel: collapsedNotchViewModel.outputAudioDeviceHUD
            )

            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDBrightnessDefaults.shared,
                hudModel: collapsedNotchViewModel.brightnessHUD
            )

            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
            )

            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
            )

            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDBrightnessDefaults.shared,
                hudModel: collapsedNotchViewModel.brightnessHUD
            )

            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
            )

            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
            )
        }
        .onReceive( notchDefaults.objectWillChange ) {
            collapsedNotchViewModel.hideHUDs()

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
