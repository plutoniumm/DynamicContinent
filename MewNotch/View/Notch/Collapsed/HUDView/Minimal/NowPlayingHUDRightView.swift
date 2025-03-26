//
//  NowPlayingHUDRightView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

import Lottie

struct NowPlayingHUDRightView: View {
    
    @ObservedObject var notchViewModel: CollapsedNotchViewModel
    
    var body: some View {
        if let nowPlayingModel = notchViewModel.nowPlayingMedia {
            LottieView(
                animation: MewNotch.Lotties.visualizer
            )
            .animationSpeed(0.2)
            .playbackMode(
                nowPlayingModel.isPlaying
                ? .playing(
                    .fromProgress(
                        0,
                        toProgress: 1,
                        loopMode: .loop
                    )
                )
                : .paused
            )
            .scaledToFit()
            .padding(8)
            .frame(
                width: notchViewModel.notchSize.height,
                height: notchViewModel.notchSize.height
            )
            .transition(
                .move(
                    edge: .leading
                )
                .combined(
                    with: .opacity
                )
            )
            .padding(
                .init(
                    top: 0,
                    leading: -notchViewModel.extraNotchPadSize.width / 2,
                    bottom: 0,
                    trailing: notchViewModel.extraNotchPadSize.width / 2
                )
            )
        }
    }
}
