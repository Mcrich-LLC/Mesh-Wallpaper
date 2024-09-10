//
//  ColorPreset.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/18/24.
//

import Foundation
import SwiftUI

enum ColorPreset: String, CaseIterable {
    case cool, warm
    
    var localized: String {
        switch self {
        case .cool:
            String(localized: "cool")
        case .warm:
            String(localized: "warm")
        }
    }
    
    var colorArray: [UIColor] {
        switch self {
        case .cool:
            return [.systemCyan, .systemGreen, .systemIndigo, .systemTeal, .systemCyan, .systemMint, .systemIndigo, .systemMint, .systemBlue]
        case .warm:
            return [.systemPink, .systemPurple, .systemOrange, .systemTeal, .systemPink, .systemOrange, .systemMint, .systemPink, .systemPurple]
        }
    }
}
