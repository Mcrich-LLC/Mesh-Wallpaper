//
//  MeshGenerator.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct MeshGenerator: View {
    @State var viewModel = MeshGeneratorViewModel()
    var body: some View {
        VStack {
            MeshGradient(width: 3, height: 4, points: viewModel.points, colors: viewModel.colors)
                .overlay {
                    GeometryReader { geo in
                        ZStack {
                            ForEach(viewModel.overlayPoints.indices, id: \.self) { pointIndex in
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .position(x: viewModel.overlayPoints[pointIndex].x*geo.size.width, y: viewModel.overlayPoints[pointIndex].y*geo.size.height)
                                    .gesture(
                                        DragGesture()
                                            .onChanged({ gesture in
                                                viewModel.overlayPoints[pointIndex].x = gesture.location.x/geo.size.width
                                                viewModel.overlayPoints[pointIndex].y = gesture.location.y/geo.size.height
                                            })
                                    )
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    MeshGenerator()
        .preferredColorScheme(.dark)
}
