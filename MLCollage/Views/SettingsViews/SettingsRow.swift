//
//  settingsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/3/25.
//

import SwiftData
import SwiftUI

struct SettingsRow: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding([.horizontal, .top])
            VStack {
                SettingsViewWrapper()
            }
            .background(.white.opacity(0.05))
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: RectangleCornerRadii(
                        topLeading: 10.0,
                        bottomLeading: 30.0,
                        bottomTrailing: 30.0,
                        topTrailing: 10.0
                    )
                )
            )
            .foregroundStyle(.app)
            .padding([.horizontal, .bottom], 15.0)
        }
        .background(.accent)
        .clipShape(.rect(cornerRadius: 10.0))
        .foregroundStyle(.app)
        .shadow(radius: 5.0)
    }
}
