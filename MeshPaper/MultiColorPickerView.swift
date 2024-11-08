//
//  MultiColorPickerView.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI
import SwiftUIIntegratedSheet

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
                        ColorItem(title: "Color \(colorIndex+1)", options: MeshGeneratorViewModel.colorOptions, selectedColor: $meshViewModel.colors[colorIndex])
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

struct ColorItem: View {
    let title: String
    let options: [UIColor]
    @Binding var selectedColor: UIColor
    
    @State private var isPickerShown: Bool = false
    
    var body: some View {
        Button {
            isPickerShown.toggle()
        } label: {
            HStack {
                Image(systemName: "chevron.up.chevron.down")
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(uiColor: selectedColor))
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 50)
            }
        }
        .colorPickerPopoverSheet(isPresented: $isPickerShown, title: title, options: options, selectedColor: $selectedColor)
    }
}

private extension View {
    func colorPickerPopoverSheet(isPresented: Binding<Bool>, title: String, options: [UIColor], selectedColor: Binding<UIColor>) -> some View {
        modifier(ColorPickerPopoverSheetModifier(isPresented: isPresented, title: title, options: options, selectedColor: selectedColor))
    }
}

private struct ColorPickerPopoverSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    let title: String
    let options: [UIColor]
    @Binding var selectedColor: UIColor
    
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            content
                .sheet(isPresented: $isPresented) {
                    ColorPicker(title: title, options: options, selectedColor: $selectedColor)
                        .presentationDetents([.fraction(0.5)])
                }
        } else {
            content
                .popover(isPresented: $isPresented) {
                    ColorPicker(title: title, options: options, selectedColor: $selectedColor)
                        .frame(minWidth: 500, minHeight: 450)
                }
        }
    }
}

struct ColorPicker: View {
    let title: String
    let options: [UIColor]
    @Binding var selectedColor: UIColor
    @Environment(\.dismiss) var dismiss
    
    
    private let columns: [GridItem] = .init(repeating: GridItem(), count: 5)
    @State private var isShowingCustomColorSheet: Bool = false
    
    var selectedColorAsColorBinding: Binding<Color> {
        .init(get: { Color(uiColor: selectedColor) }, set: { selectedColor = UIColor($0) })
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: columns) {
                ForEach(options, id: \.self) { color in
                    Button {
                        withAnimation {
                            selectedColor = color
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(uiColor: color))
                            .aspectRatio(1, contentMode: .fit)
                            .overlay {
                                if selectedColor == color {
                                    checkmark
                                }
                            }
                    }
                    .foregroundStyle(color == .black ? Color.accentColor : .white)
                    .padding(selectedColor == color ? -2 : 0)
                }
                Button {
                    isShowingCustomColorSheet.toggle()
                } label: {
                    Group {
                        if !options.contains(selectedColor) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(uiColor: selectedColor))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center, angle: .zero)
                                )
                        }
                    }
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            if !options.contains(selectedColor) {
                                checkmark
                            }
                        }
                }
                .foregroundStyle(.white)
                .padding(!options.contains(selectedColor) ? -2 : 0)
            }
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
            }
//            .buttonBorderShape(.roundedRectangle(radius: 10))
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.all)
        .colorPickerPopover(isPresented: $isShowingCustomColorSheet, selection: selectedColorAsColorBinding)
    }
    
    var checkmark: some View {
        Image(systemName: "checkmark")
            .resizable()
//            .bold()
            .aspectRatio(contentMode: .fit)
            .padding()
    }
}
