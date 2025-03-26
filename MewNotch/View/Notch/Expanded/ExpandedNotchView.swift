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
                HStack {
                    OnlyNotchView(
                        notchSize: notchViewModel.notchSize
                    )
                }
                
                NowPlayingDetailView(
                    namespace: namespace,
                    notchViewModel: notchViewModel,
                    nowPlayingModel: expandedNotchViewModel.nowPlayingMedia ?? .Placeholder
                )
            }
        }
    }
}
