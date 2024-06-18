//
//  SheetContainer.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct SheetContainer<Content: View>: View {
    let title: String
    @Binding var isShown: Bool
//    @Binding var offsetY: CGFloat
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .bold()
                    .textCase(nil)
                    .foregroundStyle(Color.primary)
                Spacer()
                Button {
                    withAnimation {
                        isShown = false
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
            }
            ScrollView {
                VStack {
                    ForEach(subviewOf: content) { subview in
                        subview
                    }
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .ignoresSafeArea()
        }
        .padding(.horizontal)
    }
}
