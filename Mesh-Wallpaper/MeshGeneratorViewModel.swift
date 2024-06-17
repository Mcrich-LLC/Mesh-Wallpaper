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
    
    var overlayPoints: [CGPoint] = [
        .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
        .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5),
        .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1),
    ]
    
    var colors: [Color] = [
        .purple, .purple, .purple,
        .blue, .blue, .blue,
        .green, .green, .green
    ]
    
}
