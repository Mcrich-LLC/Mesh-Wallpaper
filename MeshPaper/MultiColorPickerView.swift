//
//  MultiColorPickerView.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct MultiColorPickerView: View {
    @EnvironmentObject var meshViewModel: MeshGeneratorViewModel
    @State var colorPreset: ColorPreset? = nil
    
    var body: some View {
        SheetContainer(title: String(localized: "Colors"), isShown: $meshViewModel.isShowingColorPicker, sheetScrollOffset: $meshViewModel.sheetOffsetY, header: {
            Picker("", selection: $colorPreset) {
                if colorPreset == nil {
                    Text("Custom")
                        .tag(ColorPreset?.none)
                }
                
                ForEach(ColorPreset.allCases, id: \.self) { preset in
                    Text(preset.localized.capitalized)
                        .tag(preset)
                }
            }
            
            Button {
                meshViewModel.randomizeGradientColors()
            } label: {
                Image(systemName: "shuffle")
            }
        }) {
            Section {
                ForEach($meshViewModel.colors.indices, id: \.self) { colorIndex in
                    HStack {
                        Text("Color \(colorIndex+1)")
                        Spacer()
                        Picker("", selection: $meshViewModel.colors[colorIndex]) {
                            ForEach(MeshGeneratorViewModel.colorOptions, id: \.self) { color in
                                Text(color.accessibilityName.capitalized)
                                
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
        .onAppear {
            updateColorPreset()
        }
        .onChange(of: colorPreset) {
            setColorPreset()
        }
        .onChange(of: meshViewModel.colors) {
            updateColorPreset()
        }
    }
    
    func setColorPreset() {
        guard let colorPreset, colorPreset.colorArray != meshViewModel.colors else { return }
        
        withAnimation {
            meshViewModel.colors = colorPreset.colorArray
        }
    }
    
    func updateColorPreset() {
        guard let preset = ColorPreset.allCases.first(where: { $0.colorArray == meshViewModel.colors }) else { 
            colorPreset = nil
            return
        }
        
        colorPreset = preset
    }
}

#Preview {
    MultiColorPickerView()
        .environmentObject(MeshGeneratorViewModel())
}
