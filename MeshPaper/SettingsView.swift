//
//  SettingsView.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @EnvironmentObject var meshViewModel: MeshGeneratorViewModel
    
    var body: some View {
        SheetContainer(title: "Settings", isShown: $meshViewModel.isShowingSettings, sheetScrollOffset: $meshViewModel.sheetOffsetY, header: {
            Button {
                meshViewModel.randomizeGradientPoints()
            } label: {
                Image(systemName: "shuffle")
            }
        }) {
            Toggle("Show Points", isOn: $meshViewModel.isShowingPoints)
            
            Divider()
            
            Toggle("Show Glow", isOn: $meshViewModel.isShowingHue)
            
            Divider()
            
            HStack {
                Text("Save Mode")
                Spacer()
                Picker("", selection: $meshViewModel.shareMode) {
                    ForEach(ShareMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue.capitalized)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Divider()
            
            HStack {
                Text("Export Image Scale")
                Spacer()
                Stepper(value: $meshViewModel.exportImageScale, in: 0...1, step: 0.1) {
                    HStack {
                        Spacer()
                        Text("\(meshViewModel.exportImageScale)".prefix(3))
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Aspect Ratio")
                Spacer()
                Picker("", selection: $meshViewModel.aspectRatio) {
                    Section("Portrait") {
                        ForEach(MeshGeneratorViewModel.portraitAspectRatioOptions, id: \.self) { size in
                            Text("\(Int(size.width))x\(Int(size.height))")
                                .tag(size)
                        }
                    }
                    Section("Landscape") {
                        ForEach(MeshGeneratorViewModel.portraitAspectRatioOptions.map({ CGSize(width: $0.height, height: $0.width)} ), id: \.self) { size in
                            Text("\(Int(size.width))x\(Int(size.height))")
                                .tag(size)
                        }
                    }
                    Section("Square") {
                        ForEach(MeshGeneratorViewModel.squareAspectRatioOptions, id: \.self) { size in
                            Text("\(Int(size.width))x\(Int(size.height))")
                                .tag(size)
                        }
                    }
                }
                .pickerStyle(.menu)
            }
                        
            Divider()
            
            HStack {
                if meshViewModel.userImageItem != nil {
                    Button {
                        meshViewModel.userImageItem = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(.red)
                }
                PhotosPicker(selection: $meshViewModel.userImageItem) {
                    HStack {
                        if meshViewModel.userImageItem == nil {
                            Spacer()
                        }
                        Text(meshViewModel.userImageItem == nil ? "Insert Image" : "Change Image")
                        Spacer()
                    }
                }
                
                if meshViewModel.userImageItem != nil {
                    Spacer()
                    Picker("", selection: $meshViewModel.userImageContentMode) {
                        ForEach(ContentMode.allCases, id: \.self) { content in
                            Text("\(content)".capitalized)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(MeshGeneratorViewModel())
}
