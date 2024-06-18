//
//  DragToDismissModifier.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import Foundation
import SwiftUI

struct DragToDismissModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var offsetY: CGFloat
    
    func body(content: Content) -> some View {
            content
                .offset(y: offsetY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard isPresented else { return }
                            
                            guard self.offsetY < 160 else {
                                stopPresenting()
                                return
                            }
                            
                            self.offsetY = max(0, value.translation.height)
                        }
                        .onEnded { value in
                            guard self.offsetY < 120 else {
                                stopPresenting()
                                return
                            }
                            
                            // Snap back to original position
                            withAnimation {
                                self.offsetY = 0
                            }
                        }
                )
    }
    
    func stopPresenting() {
        withAnimation {
            self.isPresented = false
            self.offsetY = 0
        }
    }
}

extension View {
    func dragToDismiss(isPresented: Binding<Bool>, offsetY: Binding<CGFloat>) -> some View {
        self.modifier(DragToDismissModifier(isPresented: isPresented, offsetY: offsetY))
    }
}

