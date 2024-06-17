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
            GeometryReader { geo in
                MeshGradient(width: 3, height: 4, points: viewModel.points, colors: viewModel.colors)
                    .overlay {
                        GeometryReader { pointGeo in
                            ZStack {
                                ForEach(viewModel.overlayPoints.indices, id: \.self) { pointIndex in
                                    Circle()
                                        .frame(width: 25, height: 25)
                                        .position(x: viewModel.overlayPoints[pointIndex].x*pointGeo.size.width, y: viewModel.overlayPoints[pointIndex].y*pointGeo.size.height)
                                        .gesture(
                                            DragGesture()
                                                .onChanged({ gesture in
                                                    viewModel.updatePoint(pointIndex, with: gesture.location, from: pointGeo.size)
                                                })
                                        )
                                }
                            }
                        }
                    }
                    .aspectRatio(9/16, contentMode: .fit)
                    .scaleEffect(0.9)
            }
            HStack {
                Button("Reset", action: viewModel.resetGradient)
                    .buttonStyle(.bordered)
                Button("Randomize", action: viewModel.randomizeGradient)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    MeshGenerator()
        .preferredColorScheme(.dark)
}
