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
        }
    }
}
