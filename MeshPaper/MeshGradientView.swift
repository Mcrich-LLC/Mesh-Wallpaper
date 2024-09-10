//
//  MeshGradientView.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct MeshGradientView/*<Content: View>*/: View {
    let width: Int
    let height: Int
    let points: [SIMD2<Float>]
    let colors: [Color]
    let isHueEnabled: Bool
    let isRenderingAsImage: Bool
    
    var blurRadius: CGFloat {
        let radius: CGFloat = 20
        
        return isRenderingAsImage ? radius*2.5 : radius
    }
    
    init(width: Int, height: Int, points: [SIMD2<Float>], colors: [UIColor], hueEnabled: Bool = true, renderForImage: Bool = false) {
        self.width = width
        self.height = height
        self.points = points
        self.colors = colors.map({ Color(uiColor: $0) })
        self.isRenderingAsImage = renderForImage
        self.isHueEnabled = hueEnabled
    }

    var body: some View {
        ZStack {
            if isHueEnabled {
                mesh
                    .blur(radius: blurRadius)
            }
            mesh
        }
    }
    
    var mesh: some View {
        MeshGradient(width: width, height: height, points: points, colors: colors)
    }
}

struct MeshGradientImageBackground: View {
    let image: Image?
    let contentMode: ContentMode
    let aspectRatio: CGSize
    
    init(image: Image?, contentMode: ContentMode, aspectRatio: CGSize) {
        self.image = image
        self.contentMode = contentMode
        self.aspectRatio = aspectRatio
    }
    
    var body: some View {
        if let image {
            switch contentMode {
            case .fit:
                image
                    .resizable()
                    .scaledToFit()
            case .fill:
                image
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(aspectRatio.width/aspectRatio.height, contentMode: .fit)
            }
        }
    }
}
