//
//  SettingsView.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var meshViewModel: MeshGeneratorViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section {
                Toggle("Show Points", isOn: $meshViewModel.isShowingPoints)
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
                HStack {
                    Text("Aspect Ratio")
                    Spacer()
                    Picker("", selection: $meshViewModel.aspectRatio) {
                        Section("Portrait") {
                            ForEach(MeshGeneratorViewModel.aspectRatioOptions, id: \.self) { size in
                                Text("\(Int(size.width))x\(Int(size.height))")
                                    .tag(size)
                            }
                        }
                        Section("Landscape") {
                            ForEach(MeshGeneratorViewModel.aspectRatioOptions.map({ CGSize(width: $0.height, height: $0.width)} ), id: \.self) { size in
                                Text("\(Int(size.width))x\(Int(size.height))")
                                    .tag(size)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                }
            } header: {
                HStack {
                    Text("Settings")
                        .font(.title)
                        .bold()
                        .textCase(nil)
                        .foregroundStyle(Color.primary)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
