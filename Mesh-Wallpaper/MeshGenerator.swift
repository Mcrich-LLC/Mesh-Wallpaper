//
//  MeshGenerator.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct MeshGenerator: View {
    @StateObject var viewModel = MeshGeneratorViewModel()
    var body: some View {
        VStack {
            Text("Mesh Wallpaper")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            GeometryReader { geo in
                MeshGradient(width: 3, height: 3, points: viewModel.points, colors: viewModel.colors)
                    .overlay {
                        if viewModel.isShowingPoints {
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
                    }
                    .aspectRatio(9/16, contentMode: .fit)
                    .scaleEffect(0.9)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            HStack {
                Button {
                    viewModel.isShowingSettings.toggle()
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                }
                Spacer()
                
                Button("Reset", action: viewModel.resetGradient)
                    .buttonStyle(.bordered)
                Button("Randomize", action: viewModel.randomizeGradient)
                    .buttonStyle(.borderedProminent)
                HStack {
                    switch viewModel.shareMode {
                    case .save:
                        Button(action: viewModel.saveAsPhoto) {
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                        }
                    case .share:
                        let image = Image(uiImage: viewModel.meshImage)
                        ShareLink(item: image, preview: SharePreview("Wallpaper", icon: image))
                            .labelStyle(.iconOnly)
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                Button {
                    viewModel.isShowingColorPicker.toggle()
                } label: {
                    Circle()
                        .fill(
                            AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center, angle: .zero)
                        )
                        .frame(height: 30)
                }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $viewModel.isShowingSettings) {
            SettingsView()
                .presentationDetents([.fraction(0.25)])
        }
        .sheet(isPresented: $viewModel.isShowingColorPicker) {
            MultiColorPickerView()
                .presentationDetents([.medium, .large])
        }
        .alert("Uh Oh", isPresented: $viewModel.isShowingErrorAlert, actions: {
            Button("Ok") {}
        }, message: {
            Text(viewModel.errorAlertMessage)
        })
        .alert("Success", isPresented: $viewModel.isShowingSaveSuccessAlert, actions: {
            Button("Done") {}
        }, message: {
            Text("You image has been saved to Photos")
        })
        .onChange(of: viewModel.overlayPoints, {
            viewModel.generateMeshImage()
        })
        .environmentObject(viewModel)
    }
}

#Preview {
    MeshGenerator()
        .preferredColorScheme(.dark)
}
