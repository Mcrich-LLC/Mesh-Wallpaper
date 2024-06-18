//
//  MultiColorPickerView.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct MultiColorPickerView: View {
    @EnvironmentObject var meshViewModel: MeshGeneratorViewModel
    
    var body: some View {
        SheetContainer(title: "Colors", isShown: $meshViewModel.isShowingColorPicker) {
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
                if colorIndex != meshViewModel.colors.count-1 {
                    Divider()
                }
            }
        }
    }
}

#Preview {
    MultiColorPickerView()
}
