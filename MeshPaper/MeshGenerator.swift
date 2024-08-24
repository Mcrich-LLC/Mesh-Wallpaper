//
//  MeshGenerator.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct MeshGenerator: View {
    @StateObject var viewModel = MeshGeneratorViewModel()

    var body: some View {
        VStack {
            Text(verbatim: "MeshPaper")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            MeshGradientView(width: 3, height: 3, points: viewModel.points, colors: viewModel.colors, hueEnabled: viewModel.isShowingHue)
                .opacity(viewModel.meshOpacity)
                .background(content: {
                    MeshGradientImageBackground(image: viewModel.userImage, contentMode: viewModel.userImageContentMode, aspectRatio: viewModel.aspectRatio)
                })
                .clipped()
                .overlay {
                    if viewModel.isShowingPoints {
                        GeometryReader { pointGeo in
                            ZStack {
                                ForEach(viewModel.overlayPoints.indices, id: \.self) { pointIndex in
                                    Circle()
                                        .fill(Color.white)
                                        .overlay(content: {
                                            if viewModel.isShowingColorPicker {
                                                Text(verbatim: "\(pointIndex+1)")
                                                    .foregroundStyle(Color.black)
                                            }
                                        })
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
                        .padding(1)
                    }
                }
                .scaleEffect(0.9)
                .aspectRatio(viewModel.aspectRatio.width/viewModel.aspectRatio.height, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.bottom, -viewModel.sheetOffsetY)
            
            VStack {
                if viewModel.isShowingSettings {
                    SettingsView()
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                } else if viewModel.isShowingColorPicker {
                    MultiColorPickerView()
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                } else {
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.isShowingSettings = true
                            }
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
                                        .frame(height: 20)
                                }
                            case .share:
                                let image = Image(uiImage: viewModel.meshImage)
                                ShareLink(item: image, preview: SharePreview("Wallpaper", icon: image)) {
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                viewModel.isShowingColorPicker = true
                            }
                        } label: {
                            Circle()
                                .fill(
                                    AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center, angle: .zero)
                                )
                                .frame(height: 30)
                        }
                    }
                    .frame(height: 30)
                    .padding(.horizontal)
                    .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
                }
            }
            .padding(.vertical)
            .padding(.bottom)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 25, topTrailingRadius: 25))
            .dragToDismiss(isPresented: viewModel.sheetDragableBinding, offsetY: $viewModel.sheetOffsetY)
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
        .onChange(of: viewModel.overlayPoints) { _, newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                guard newValue == viewModel.overlayPoints else { return }
                
                viewModel.generateMeshImage()
            }
        }
        .onChange(of: viewModel.userImageItem) {
            Task {
                if let loaded = try? await viewModel.userImageItem?.loadTransferable(type: Image.self) {
                    viewModel.userImage = loaded
                } else {
                    viewModel.userImage = nil
                    print("Failed")
                }
            }
        }
        .environmentObject(viewModel)
        .ignoresSafeArea(edges: [.bottom])
    }
}

#Preview {
    MeshGenerator()
        .preferredColorScheme(.dark)
}
