//
//  CollapsedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

import Lottie

struct CollapsedNotchView: View {
    
    @StateObject private var notchViewModel = CollapsedNotchViewModel.init()
    
    @StateObject var defaultsManager = MewDefaultsManager.shared
    
    var isHovered: Bool = false
    
    var body: some View {
        VStack(
            spacing: 0
        ) {
            HStack(
                spacing: 0
            ) {
                if defaultsManager.hudStyle == .Minimal, let hudValue = notchViewModel.hudValue {
                    if let hudLottie = notchViewModel.hudIcon {
                        Text(
                            "000 %"
                        )
                        .font(.title3.bold())
                        .frame(
                            height: notchViewModel.notchSize.height
                        )
                        .opacity(0)
                        .overlay {
                            LottieView(
                                animation: hudLottie
                            )
                            .currentProgress(Double(hudValue))
                            .configuration(
                                .init(
                                    renderingEngine: .mainThread
                                )
                            )
                            .colorInvert()
                            .scaledToFit()
                            .padding(8)
                        }
                        .padding(
                            .leading,
                            notchViewModel.extraNotchPadSize.width / 2
                        )
                        .transition(
                            .offset(
                                x: notchViewModel.extraNotchPadSize.width / 2
                            )
                            .combined(
                                with: .opacity
                            )
                        )
                    }
                }
                
                OnlyNotchView(
                    notchSize: notchViewModel.notchSize
                )
                
                if defaultsManager.hudStyle == .Minimal {
                    if let hudValue = notchViewModel.hudValue {
                        Text(
                            "000%"
                        )
                        .font(.title3.bold())
                        .frame(
                            height: notchViewModel.notchSize.height
                        )
                        .opacity(0)
                        .overlay {
                            AnimatedTextView(
                                value: Double(hudValue * 100)
                            ) { value in
                                Text(
                                    String(
                                        format: "%02.0f",
                                        value
                                    )
                                )
                                .font(.title3.bold())
                                .foregroundStyle(Color.white)
                            }
                        }
                        .padding(
                            .trailing,
                            notchViewModel.extraNotchPadSize.width / 2
                        )
                        .transition(
                            .offset(
                                x: -notchViewModel.extraNotchPadSize.width / 2
                            )
                            .combined(
                                with: .opacity
                            )
                        )
                    }
                }
            }
            
            if defaultsManager.hudStyle == .Progress {
                ProgressHUDView(
                    notchViewModel: notchViewModel
                )
            } else if defaultsManager.hudStyle == .Notched {
                NotchedHUDView(
                    notchViewModel: notchViewModel
                )
            }
        }
        .onReceive(
            defaultsManager.objectWillChange
        ) {
            notchViewModel.hudTimer?.invalidate()
            
            notchViewModel.hudIcon = nil
            notchViewModel.hudValue = nil
            
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
    CollapsedNotchView()
}
