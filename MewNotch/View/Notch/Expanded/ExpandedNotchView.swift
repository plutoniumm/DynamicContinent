//
//  ExpandedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/03/25.
//

import SwiftUI

struct ExpandedNotchView: View {
    
    var namespace: Namespace.ID
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    @StateObject private var expandedNotchViewModel: ExpandedNotchViewModel = .init()
    
    var body: some View {
        if notchViewModel.isExpanded {
            VStack {
                OnlyNotchView(
                    notchSize: notchViewModel.notchSize
                )
                
                HStack(
                    spacing: 12
                ) {
                    NowPlayingDetailView(
                        namespace: namespace,
                        notchViewModel: notchViewModel,
                        nowPlayingModel: expandedNotchViewModel.nowPlayingMedia ?? .Placeholder
                    )
                    
                    Divider()
                    
                    MirrorView(
                        notchViewModel: notchViewModel
                    )
                }
                .frame(
                    height: notchViewModel.notchSize.height * 3
                )
            }
            .padding(
                .init(
                    top: 0,
                    leading: 8 + notchViewModel.extraNotchPadSize.width / 2,
                    bottom: 8,
                    trailing: 8 + notchViewModel.extraNotchPadSize.width / 2
                )
            )
        }
    }
}
