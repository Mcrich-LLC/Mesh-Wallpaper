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
        VStack {
            HStack {
                Text("Settings")
                    .font(.title)
                    .bold()
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
            Toggle("Show Points", isOn: $meshViewModel.isShowingPoints)
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
