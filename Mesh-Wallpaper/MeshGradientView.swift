//
//  MeshGradientView.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct MeshGradientView/*<Content: View>*/: View {
    let width: Int
    let height: Int
    let points: [SIMD2<Float>]
    let colors: [Color]
    let isRenderingAsImage: Bool
    
    var blurRadius: CGFloat {
        let radius: CGFloat = 20
        
        return isRenderingAsImage ? radius*2.5 : radius
    }
    
    init(width: Int, height: Int, points: [SIMD2<Float>], colors: [Color], renderForImage: Bool = false) {
        self.width = width
        self.height = height
        self.points = points
        self.colors = colors
        self.isRenderingAsImage = renderForImage
    }

    var body: some View {
        ZStack {
            mesh
                .blur(radius: blurRadius)
            mesh
        }
    }
    
    var mesh: some View {
        MeshGradient(width: width, height: height, points: points, colors: colors)
    }
}
