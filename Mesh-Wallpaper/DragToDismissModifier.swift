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
                            
                            self.offsetY = max(0, value.translation.height)
                        }
                        .onEnded { value in
                            if self.offsetY > 90 {
                                // Dismiss the view if dragged down more than 90 points
                                withAnimation {
                                    self.isPresented = false
                                    self.offsetY = 0
                                }
                            } else {
                                // Snap back to original position
                                withAnimation {
                                    self.offsetY = 0
                                }
                            }
                        }
                )
    }
}

extension View {
    func dragToDismiss(isPresented: Binding<Bool>, offsetY: Binding<CGFloat>) -> some View {
        self.modifier(DragToDismissModifier(isPresented: isPresented, offsetY: offsetY))
    }
}

