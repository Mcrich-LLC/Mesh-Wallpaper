//
//  MultiColorPickerView.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct MultiColorPickerView: View {
    @EnvironmentObject var meshViewModel: MeshGeneratorViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section {
                ForEach($meshViewModel.colors.indices, id: \.self) { colorIndex in
                    HStack {
                        Text("Color \(colorIndex+1)")
                        Spacer()
                        Picker("", selection: $meshViewModel.colors[colorIndex]) {
                            ForEach(MeshGeneratorViewModel.colorOptions, id: \.self) { color in
                                Text("\(color)".capitalized)
                                    .tag(color)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            } header: {
                HStack {
                    Text("Colors")
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
    MultiColorPickerView()
}
