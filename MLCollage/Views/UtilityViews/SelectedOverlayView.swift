//
//  DeleteOverlayView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/3/25.
//

import SwiftUI

struct SelectedOverlayView: ViewModifier {
    //button state
    var isSelected: Bool

    func body(content: Content) -> some View {
        if isSelected {
            ZStack(alignment: .bottomTrailing) {
                content
                    .border(.accent, width: 3)
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .accent)
                    .offset(x: -7, y: -7)
            }
        } else {
            ZStack(alignment: .bottomTrailing) {
                content
                Image(systemName: "circle")
                    .font(.title)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.accent)
                    .offset(x: -7, y: -7)
            }
        }
    }
}

extension View {
    func selectedOverlay(_ isSelected: Bool) -> some View {
        modifier(SelectedOverlayView(isSelected: isSelected))
    }
}

#Preview {
    Text("Downtown Bus")
        .selectedOverlay(true)
}
