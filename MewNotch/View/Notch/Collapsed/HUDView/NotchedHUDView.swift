//
//  NotchedHUDView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI

struct NotchedHUDView: View {
    
    @ObservedObject var notchViewModel: CollapsedNotchViewModel
    
    var body: some View {
        if let hudIcon = notchViewModel.hudIcon, let hudValue = notchViewModel.hudValue {
            VStack {
                hudIcon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.white)
                
                RoundedRectangle(
                    cornerRadius: 2
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
                            cornerRadius: 2
                        )
                        .fill(
                            Color.accentColor
                        )
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
            }
            .padding(
                .init([.leading, .bottom, .trailing]),
                16
            )
            .frame(
                width: notchViewModel.notchSize.width - notchViewModel.extraNotchPadSize.width,
                height: notchViewModel.notchSize.width - notchViewModel.notchSize.height - notchViewModel.extraNotchPadSize.width
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
    NotchedHUDView(
        notchViewModel: .init())
}
