//
//  DeleteOverlayView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/3/25.
//

import SwiftUI

struct SelectedOverlayView<Content: View>: View {
    //button state
    var isSelected: Bool

    //child view
    let child: @ViewBuilder () -> Content

    var body: some View {
        if isSelected {
            ZStack(alignment: .bottomTrailing) {
                child
                    .border(.accent, width: 3)
                    .padding(5.0)
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .accent)
                    .padding(7)
            }
        } else {
            ZStack(alignment: .bottomTrailing) {
                child
                    .padding(5.0)
                Image(systemName: "circle")
                    .font(.title)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.accent)
                    .padding(7)
            }
        }
    }
}

#Preview {
    var isSelected = true

    SelectedOverlayView(isSelected: isSelected, child: Text("test"))
}
