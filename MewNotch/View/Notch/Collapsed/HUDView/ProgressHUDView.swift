//
//  ProgressHUDView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

struct ProgressHUDView: View {
    
    @ObservedObject var notchViewModel: CollapsedNotchViewModel
    
    var body: some View {
        if let hudValue = notchViewModel.hudValue {
            RoundedRectangle(
                cornerRadius: 99
            )
            .fill(
                .white.opacity(
                    0.1
                )
            )
            .frame(
                height: 8
            )
            .overlay {
                GeometryReader { geometry in
                    RoundedRectangle(
                        cornerRadius: 99
                    )
                    .fill(Color.accentColor)
                    .frame(
                        width: CGFloat(hudValue) * geometry.size.width,
                        height: geometry.size.height
                    )
                    .frame(
                        width: geometry.size.width,
                        alignment: .leading
                    )
                }
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 99
                )
            )
            .background {
                RoundedRectangle(
                    cornerRadius: 99
                )
                .fill(
                    .white.opacity(
                        0.2
                    )
                )
                .blur(
                    radius: 3
                )
            }
            .padding(
                24
            )
            .frame(
                width: notchViewModel.notchSize.width,
                height: notchViewModel.notchSize.height
            )
            .transition(
                .move(
                    edge: .top
                )
                .combined(
                    with: .opacity
                )
            )
        }
    }
}

#Preview {
    ProgressHUDView(
        notchViewModel: .init()
    )
}
