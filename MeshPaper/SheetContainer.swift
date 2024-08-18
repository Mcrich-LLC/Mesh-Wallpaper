//
//  SheetContainer.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

struct SheetContainer<Header: View, Content: View>: View {
    let title: String
    @Binding var isShown: Bool
    @Binding var sheetScrollOffset: CGFloat
    private var header: (() -> Header)?
    private var content: () -> Content
    @State var scrollOffsetIsDisabled = false
    
    init(title: String, isShown: Binding<Bool>, sheetScrollOffset: Binding<CGFloat>? = nil, @ViewBuilder header: @escaping () -> Header, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._isShown = isShown
        self._sheetScrollOffset = sheetScrollOffset ?? Binding(get: {0}, set: {_ in})
        self.header = header
        self.content = content
    }
     
    init(title: String, isShown: Binding<Bool>, sheetScrollOffset: Binding<CGFloat>? = nil, @ViewBuilder content: @escaping () -> Content) where Header == EmptyView {
        self.title = title
        self._isShown = isShown
        self._sheetScrollOffset = sheetScrollOffset ?? Binding(get: {0}, set: {_ in})
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
                header?()
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
                    ForEach(sections: content()) { section in
                        VStack {
                            ForEach(subviews: section.content) { subview in
                                subview
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                                   value: -$0.frame(in: .named("scroll")).origin.y)
                        })
                    }
                    Color.clear.frame(height: 15)
                }
//                .onPreferenceChange(ViewOffsetKey.self) { (offset: CGFloat) in
//                    guard (offset < 0 || sheetScrollOffset >= 0), !scrollOffsetIsDisabled else { return }
//                    
//                    guard sheetScrollOffset < 160 else {
//                        hideFromScroll()
//                        return
//                    }
//                    
//                    sheetScrollOffset -= offset
//                }
                .onChange(of: isShown) {
                    scrollOffsetIsDisabled = !isShown
                }
            }
//            .onScrollPhaseChange({ oldPhase, newPhase in
//                if [ScrollPhase.idle, .tracking, .decelerating].contains(newPhase) && sheetScrollOffset > 120 { // Hide if at threshold and sheet stopping
//                    hideFromScroll()
//                } else if [ScrollPhase.idle, .tracking].contains(newPhase) { // Else don't hide if stopping and not at threshold
//                    withAnimation {
//                        sheetScrollOffset = 0
//                    }
//                }
//            })
            .coordinateSpace(name: "scroll")
            .ignoresSafeArea()
        }
        .padding(.horizontal)
    }
    
    func hideFromScroll() {
        scrollOffsetIsDisabled = true
        withAnimation {
            isShown = false
            sheetScrollOffset = 0
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
