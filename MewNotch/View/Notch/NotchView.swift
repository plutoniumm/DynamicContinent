//
//  NotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 25/02/25.
//

import SwiftUI

struct NotchView: View {
    
    @Namespace var nameSpace
    
    @StateObject var notchViewModel: NotchViewModel
    
    @StateObject var collapsedNotchViewModel: CollapsedNotchViewModel = .init()
    
    @State var isHovered: Bool = false
    @State var isExpanded: Bool = false
    
    @State var timer: Timer? = nil
    
    init(
        screen: NSScreen
    ) {
        self._notchViewModel = .init(
            wrappedValue: .init(
                screen: screen
            )
        )
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                CollapsedNotchView(
                    notchViewModel: notchViewModel,
                    isHovered: isHovered
                )
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
                
                SettingsLink {
                    Text("Settings")
                }
                .keyboardShortcut(
                    ",",
                    modifiers: .command
                )
                
                Button("Restart") {
                    guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
                        return
                    }
                    
                    let workspace = NSWorkspace.shared
                    
                    if let appURL = workspace.urlForApplication(
                        withBundleIdentifier: bundleIdentifier
                    ) {
                        let configuration = NSWorkspace.OpenConfiguration()
                        
                        configuration.createsNewApplicationInstance = true
                        
                        workspace.openApplication(
                            at: appURL,
                            configuration: configuration
                        )
                    }
                
                   NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("R", modifiers: .command)
                
                Button(
                    "Quit",
                    role: .destructive
                ) {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut(
                    "Q",
                    modifiers: .command
                )
            }
        )
    }
}

#Preview {
    NotchView(
        screen: .main!
    )
}
