//
//  MirrorView.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/04/25.
//

import SwiftUI
import AVFoundation

struct MirrorView: View {
    
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    @State private var isCameraViewShown: Bool = false
    
    @State private var cameraAuthStatus: AVAuthorizationStatus = .notDetermined
    
    func updateCameraAuthorization(
        animate: Bool = true
    ) {
        let status = AVCaptureDevice.authorizationStatus(
            for: .video
        )
        
        if animate {
            withAnimation {
                self.cameraAuthStatus = status
            }
        } else {
            self.cameraAuthStatus = status
        }
    }

    func requestCameraAuthorization() {
        AVCaptureDevice.requestAccess(
            for: .video
        ) { granted in
            self.updateCameraAuthorization()
        }
    }
    
    var body: some View {
        ZStack {
              Image(
                  systemName: "person.crop.circle.fill"
              )
              .resizable()
              .scaledToFit()
              .foregroundStyle(.white.opacity(0.7))
              .transition(
                  .scale
                      .combined(
                          with: .opacity
                      )
              )
        }
        .clipShape(
            Circle()
        )
        .frame(
            width: notchViewModel.notchSize.height * 3
        )
        .onTapGesture {
            if cameraAuthStatus == .authorized {
                withAnimation {
                    isCameraViewShown.toggle()
                }
            } else if cameraAuthStatus == .notDetermined {
                self.requestCameraAuthorization()
            } else if cameraAuthStatus == .denied {
                if let url = URL(
                    string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera"
                ) {
                    openURL(url)
                }
            }
        }
        .onChange(
            of: scenePhase
        ) {
            if $0 != $1 {
                self.updateCameraAuthorization()
            }
        }
        .onAppear {
            self.updateCameraAuthorization(
                animate: false
            )
        }
    }
}
