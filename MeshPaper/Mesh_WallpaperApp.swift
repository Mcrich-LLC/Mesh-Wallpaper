//
//  Mesh_WallpaperApp.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

@main
struct Mesh_WallpaperApp: App {
    var body: some Scene {  
        WindowGroup {
            MeshGenerator()
                .preferredColorScheme(.dark)
        }
    }
}
