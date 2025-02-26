//
//  CollapsedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

struct CollapsedNotchView: View {
    
    @StateObject private var notchViewModel = CollapsedNotchViewModel.init()
    
    var isHovered: Bool = false
    
    var body: some View {
        HStack(
            spacing: 0
        ) {
            if let hudIcon = notchViewModel.hudIcon {
                Text(
                    "000 %"
                )
                .font(.title3.bold())
                .frame(
                    height: notchViewModel.notchSize.height
                )
                .opacity(0)
                .overlay {
                    hudIcon
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.white)
                        .padding(8)
                        .transition(
                            .move(
                                edge: .trailing
                            )
                            .combined(
                                with: .opacity
                            )
                        )
                }
                .padding(
                    .leading,
                    notchViewModel.extraNotchPadSize.width / 2
                )
            }
            
            OnlyNotchView(
                notchSize: notchViewModel.notchSize
            )
            
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
                    .transition(
                        .move(
                            edge: .leading
                        )
                        .combined(
                            with: .opacity
                        )
                    )
                }
                .padding(
                    .trailing,
                    notchViewModel.extraNotchPadSize.width / 2
                )
            }
        }
        .background {
            Color.black
        }
        .mask {
            NotchShape()
        }
        .scaleEffect(
            isHovered ? 1.05 : 1.0,
            anchor: .top
        )
        .shadow(
            radius: isHovered ? 5 : 0
        )
    }
}

#Preview {
    CollapsedNotchView()
}
