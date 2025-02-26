//
//  NotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

struct NotchView: View {
    
    @Namespace var nameSpace
    
    @State var isHovered: Bool = false
    @State var isExpanded: Bool = false
    
    @State var timer: Timer? = nil
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                CollapsedNotchView(
                    isHovered: isHovered
                )
                .onHover { isHovered in
                    withAnimation {
                        self.isHovered = isHovered
                    }
                }
                    
                
                Spacer()
            }
            
            Spacer()
        }
        .contextMenu(
            menuItems: {
                Button(
                    "Quit App",
                    role: .destructive
                ) {
                    NSApplication.shared.terminate(nil)
                }
            }
        )
    }
}

#Preview {
    NotchView()
}
