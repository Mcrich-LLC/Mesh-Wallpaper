//
//  MeshGeneratorViewModel.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import Foundation
import SwiftUI

class MeshGeneratorViewModel: NSObject, ObservableObject {
    // Sheets
    @Published var isShowingSettings = false
    @Published var isShowingColorPicker = false
    
    // Show Error Alert
    @Published var isShowingErrorAlert = false
    @Published var errorAlertMessage = ""
    
    func showError(_ message: String) {
        errorAlertMessage = message
        isShowingErrorAlert = true
    }
    
    var points: [SIMD2<Float>] {
        overlayPoints.map({ [Float($0.x), Float($0.y)] })
    }
    
    @Published var point = CGPoint.zero
    
    @Published var overlayPoints: [CGPoint] = originalOverlayPoints
    
    @Published var isShowingPoints = true
    
    static let originalOverlayPoints: [CGPoint] = [
        .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
        .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5),
        .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1),
    ]
    
    @Published var colors: [Color] = {
        var colors: [Color] = []
        
        while colors.count < 9 {
            if let color = colorOptions.randomElement(), colors.filter({ $0 == color }).count < 3 {
                colors.append(color)
            }
        }
        return colors
    }()
    
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
        .mint
    ].sorted(by: { "\($0)" < "\($1)" })
    
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
        overlayPoints = Self.originalOverlayPoints
    }
    
    // MARK: Randomization
    
    @Published var shouldRandomizeColors = true
    @Published var shouldRandomizePoints = true
    
    func randomizeGradient() {
        withAnimation {
            
            // Randomize points if enabled
            if shouldRandomizePoints {
                for i in overlayPoints.indices {
                    overlayPoints[i].y = CGFloat.random(in: 0.1...0.9)
                    overlayPoints[i].x = CGFloat.random(in: 0.1...0.9)
                }
            }
            
            // Randomize colors if enabled
            if shouldRandomizeColors {
                var colors: [Color] = []
                
                while colors.count < 9 {
                    if let color = Self.colorOptions.randomElement(), colors.filter({ $0 == color }).count < 3 {
                        colors.append(color)
                    }
                }
                
                self.colors = colors
            }
        }
    }
    
    // MARK: Photo Gallery
    @Published var isShowingSaveSuccessAlert = false
    @Published var meshImage = UIImage()
    
    func generateMeshImage() {
        self.meshImage = meshAsImage()
    }
    
    func meshAsImage() -> UIImage {
        VStack {
            MeshGradient(width: 3, height: 3, points: self.points, colors: self.colors)
                .scaleEffect(0.8)
        }
        .preferredColorScheme(.dark)
        .frame(width: 900, height: 1600)
        .snapshot()
    }
    
    func saveAsPhoto() {
        let uiImage = meshAsImage()
        
        UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
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
