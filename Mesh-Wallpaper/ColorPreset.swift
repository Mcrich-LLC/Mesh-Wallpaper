//
//  ColorPreset.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/18/24.
//

import Foundation
import SwiftUI

enum ColorPreset: String, CaseIterable {
    case cool, warm
    
    var colorArray: [Color] {
        switch self {
        case .cool:
            return [.cyan, .green, .indigo, .teal, .cyan, .mint, .indigo, .mint, .blue]
        case .warm:
            return [.pink, .purple, .orange, .teal, .pink, .orange, .mint, .pink, .purple]
        }
    }
}
