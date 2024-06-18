//
//  SheetContainer.swift
//  Mesh-Wallpaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct SheetContainer<Header: View, Content: View>: View {
    let title: String
    @Binding var isShown: Bool
    private var header: (() -> Header)?
    private var content: () -> Content
    
    init(title: String, isShown: Binding<Bool>, @ViewBuilder header: @escaping () -> Header, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._isShown = isShown
        self.header = header
        self.content = content
    }
     
    init(title: String, isShown: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) where Header == EmptyView {
        self.title = title
        self._isShown = isShown
        self.header = nil
        self.content = content
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .bold()
                    .textCase(nil)
                    .foregroundStyle(Color.primary)
                Spacer()
                if let header {
                    header()
                }
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
                    ForEach(subviewOf: content()) { subview in
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
