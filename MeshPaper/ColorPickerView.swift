//
//  ColorPickerView.swift
//  Due Tomorrow
//
//  Created by Morris Richman on 7/5/24.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
public struct ColorPickerWithoutLabel: UIViewRepresentable {
    @Binding var selection: Color
    var supportsAlpha: Bool = true
    
    public init(selection: Binding<Color>, supportsAlpha: Bool = true) {
        self._selection = selection
        self.supportsAlpha = supportsAlpha
    }
    
    
    public func makeUIView(context: Context) -> UIColorWell {
        let well = UIColorWell()
        well.supportsAlpha = supportsAlpha
        return well
    }
    
    public func updateUIView(_ uiView: UIColorWell, context: Context) {
        uiView.selectedColor = UIColor(selection)
    }
}

extension View {
    @available(iOS 14.0, *)
    public func colorPickerSheet(isPresented: Binding<Bool>, selection: Binding<Color>, supportsAlpha: Bool = true, title: String? = nil) -> some View {
        sheet(isPresented: isPresented) {
            ColorPickerSheet(selection: selection, supportsAlpha: supportsAlpha, title: title)
                .presentationDetents([.medium])
        }
    }
    @available(iOS 14.0, *)
    public func colorPickerPopover(isPresented: Binding<Bool>, selection: Binding<Color>, supportsAlpha: Bool = true, title: String? = nil) -> some View {
        modifier(ColorPickerPopoverModifier(isPresented: isPresented, selection: selection, supportsAlpha: supportsAlpha, title: title))
    }
}

private struct ColorPickerPopoverModifier: ViewModifier {
    let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    @Binding var isPresented: Bool
    @Binding var selection: Color
    let supportsAlpha: Bool
    let title: String?
    
    func body(content: Content) -> some View {
        if userInterfaceIdiom == .phone {
            content
                .sheet(isPresented: $isPresented) {
                    ColorPickerSheet(selection: $selection, supportsAlpha: supportsAlpha, title: title)
                        .background(Color(uiColor: .systemBackground))
                        .presentationDetents([.fraction(0.85)])
                        .overlay(alignment: .topTrailing) {
                            Button {
                                isPresented = false
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                            }
                            .foregroundStyle(Color.accentColor)
                            .padding([.top, .trailing])
                        }
                        .foregroundStyle(Color.accentColor)
                }
        } else {
            content
                .popover(isPresented: $isPresented, attachmentAnchor: .point(.trailing), arrowEdge: .leading) {
                    ColorPickerSheet(selection: $selection, supportsAlpha: supportsAlpha, title: title)
                }
        }
    }
}

@available(iOS 14.0, *)
private struct ColorPickerSheet: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selection: Color
    var supportsAlpha: Bool
    var title: String?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection, dismiss: dismiss)
    }
    
    class Coordinator: NSObject, UIColorPickerViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
        @Binding var selection: Color
        let dismiss: DismissAction
        
        init(selection: Binding<Color>, dismiss: DismissAction) {
            self._selection = selection
            self.dismiss = dismiss
        }
        
        func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            selection = Color(viewController.selectedColor)
        }
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            dismiss()
        }
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            dismiss()
        }
    }
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let modal = UIColorPickerViewController()
        modal.selectedColor = UIColor(selection)
        modal.supportsAlpha = supportsAlpha
        modal.title = title
        modal.delegate = context.coordinator
        modal.presentationController?.delegate = context.coordinator
        return modal
    }
    
    func updateUIViewController(_ uiView: UIColorPickerViewController, context: Context) {
    }
}
