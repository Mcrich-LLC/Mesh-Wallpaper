//
//  MeshGeneratorViewModel.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import Foundation
import SwiftUI

@Observable
class MeshGeneratorViewModel {
    var points: [SIMD2<Float>] {
        overlayPoints.map({ [Float($0.x), Float($0.y)] })
    }
    
    var point = CGPoint.zero
    
    var overlayPoints: [CGPoint] = originalOverlayPoints
    
    static let originalOverlayPoints: [CGPoint] = [
        .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
        .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5),
        .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1),
    ]
    
    var colors: [Color] = {
        var colors: [Color] = []
        
        while colors.count < 9 {
            if let color = colorOptions.randomElement(), colors.filter({ $0 == color }).count < 3 {
                colors.append(color)
            }
        }
        return colors
    }()
    
    static let colorOptions: [Color] = [
        .purple,
        .blue,
        .green,
        .yellow,
        .red,
        .orange,
        .cyan,
        .indigo,
        .pink,
        .mint
    ]
    
    func updatePoint(_ index: Int, with location: CGPoint, from size: CGSize) {
        if (CGFloat(0)...size.width).contains(location.x) {
            self.overlayPoints[index].x = location.x/size.width
        }
        if (CGFloat(0)...size.height).contains(location.x) {
            self.overlayPoints[index].y = location.y/size.height
        }
    }
    
    func resetGradient() {
        overlayPoints = Self.originalOverlayPoints
    }
    
    // MARK: Randomization
    
    var shouldRandomizeColors = true
    var shouldRandomizePoints = true
    
    func randomizeGradient() {
        withAnimation {
            
            // Randomize points if enabled
            if shouldRandomizePoints {
                for i in overlayPoints.indices {
                    overlayPoints[i].y = CGFloat.random(in: 0.1...0.9)
                    overlayPoints[i].x = CGFloat.random(in: 0.1...0.9)
                }
            }
            
            // Randomize colors if enabled
            if shouldRandomizeColors {
                var colors: [Color] = []
                
                while colors.count < 9 {
                    if let color = Self.colorOptions.randomElement(), colors.filter({ $0 == color }).count < 3 {
                        colors.append(color)
                    }
                }
                
                self.colors = colors
            }
        }
    }
}
