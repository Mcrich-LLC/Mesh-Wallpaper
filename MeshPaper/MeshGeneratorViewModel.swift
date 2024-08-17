//
//  MeshGeneratorViewModel.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import Foundation
import SwiftUI
import PhotosUI

class MeshGeneratorViewModel: NSObject, ObservableObject {
    // Sheets
    @Published var isShowingSettings = false
    @Published var isShowingColorPicker = false
    @Published var sheetOffsetY: CGFloat = 0
    var sheetDragableBinding: Binding<Bool> {
        Binding {
            self.isShowingSettings || self.isShowingColorPicker
        } set: { newValue in
            if !newValue {
                self.isShowingSettings = false
                self.isShowingColorPicker = false
            }
        }
    }
    
    // User Image
    @Published var userImageItem: PhotosPickerItem?
    @Published var userImage: Image?
    @Published var userImageContentMode: ContentMode = .fit
    
    // Show Error Alert
    @Published var isShowingErrorAlert = false
    @Published var errorAlertMessage = ""
    
    func showError(_ message: String) {
        errorAlertMessage = message
        isShowingErrorAlert = true
    }
    
    // MARK: Mesh Properties
    @Published var aspectRatio = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: 4, height: 3) : CGSize(width: 9, height: 16)
    
    static let portraitAspectRatioOptions: [CGSize] = [
        // Portrait Only, Landscape dynamically handled
        .init(width: 9, height: 16),
        .init(width: 3, height: 4),
    ]
    
    static let squareAspectRatioOptions: [CGSize] = [
        .init(width: 2, height: 2),
    ]
    
    var points: [SIMD2<Float>] {
        overlayPoints.map({ [Float($0.x), Float($0.y)] })
    }
    
    @Published var overlayPoints: [CGPoint] = originalOverlayPoints
    
    @Published var isShowingPoints = true
    @AppStorage("isShowingHue") var isShowingHue = true
    
    static let originalOverlayPoints: [CGPoint] = [
        .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
        .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5),
        .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1),
    ]
    
    @Published var colors: [Color] = randomColors()
    
    static func randomColors() -> [Color] {
        var colors: [Color] = []
        
        while colors.count < 9 {
            if let color = colorOptions.randomElement(), colors.filter({ $0 == color }).count < 3, ![Color.black, .brown, .gray].contains(color) {
                colors.append(color)
            }
        }
        return colors
    }
    
    static let colorOptions: [Color] = [
        .purple,
        .blue,
        .green,
        .yellow,
        .red,
        .orange,
        .cyan,
        .indigo,
        .pink,
        .mint,
        .teal,
        .black,
        .brown,
        .gray
    ].sorted(by: { "\($0)" < "\($1)" })
    
    // MARK: Mesh Methods
    func updatePoint(_ index: Int, with location: CGPoint, from size: CGSize) {
        // Set x within bounds
        if location.x <= 0 {
            self.overlayPoints[index].x = 0
        } else if location.x >= size.width {
            self.overlayPoints[index].x = 1
        } else {
            self.overlayPoints[index].x = location.x/size.width
        }
        
        // Set y within bounds
        if location.y <= 0 {
            self.overlayPoints[index].y = 0
        } else if location.y >= size.height {
            self.overlayPoints[index].y = 1
        } else {
            self.overlayPoints[index].y = location.y/size.height
        }
    }
    
    func resetGradient() {
        withAnimation {
            overlayPoints = Self.originalOverlayPoints
        }
    }
    
    // MARK: Randomization
    
    @Published var shouldRandomizeColors = true
    @Published var shouldRandomizePoints = true
    
    func randomizeGradientPoints() {
        withAnimation {
            for i in overlayPoints.indices {
                overlayPoints[i].y = CGFloat.random(in: 0.1...0.9)
                overlayPoints[i].x = CGFloat.random(in: 0.1...0.9)
            }
        }
    }
    
    func randomizeGradientColors() {
        withAnimation {
            self.colors = Self.randomColors()
        }
    }
    
    func randomizeGradient() {
        // Randomize points if enabled
        if shouldRandomizePoints {
            randomizeGradientPoints()
        }
        
        // Randomize colors if enabled
        if shouldRandomizeColors {
            randomizeGradientColors()
        }
    }
    
    // MARK: Photo Gallery
    @Published var isShowingSaveSuccessAlert = false
    @Published var meshImage = UIImage()
    @AppStorage("shareMode") var shareMode: ShareMode = .save
    @AppStorage("exportImageScale") var exportImageScale: Double = 1
    
    func generateMeshImage() {
        self.meshImage = meshAsImage()
    }
    
    func meshAsImage() -> UIImage {
        // Render mesh as photo
        VStack {
            MeshGradientView(width: 3, height: 3, points: self.points, colors: self.colors, hueEnabled: isShowingHue, renderForImage: true)
                .background(content: {
                    MeshGradientImageBackground(image: userImage, contentMode: userImageContentMode)
                })
                .clipped()
                .scaleEffect(exportImageScale)
        }
        .preferredColorScheme(.dark)
        .frame(width: aspectRatio.width*100, height: aspectRatio.height*100)
        .snapshot()
    }
    
    func saveAsPhoto() {
        let uiImage = meshAsImage()
        
        // Save to photos app
        UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// Handle UIImageWriteToSavedPhotosAlbum
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showError(error.localizedDescription)
        } else {
            isShowingSaveSuccessAlert.toggle()
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .black
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

enum ShareMode: String, CaseIterable {
    case save
    case share
}
