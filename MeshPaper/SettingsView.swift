//
//  SettingsView.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

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
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(MeshGeneratorViewModel())
}
