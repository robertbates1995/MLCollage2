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
            HStack {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Spacer()
            }
            VStack {
                SettingsViewWrapper()
            }
        }
    }
}
