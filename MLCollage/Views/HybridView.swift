//
//  HybridView.swift
//  MLCollage
//
//  Created by Robert Bates on 6/17/25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct HybridView: View {
    @State var title: String = "Test Title"
    let backgroundColor: Color = Color(UIColor.secondarySystemBackground)

    var body: some View {
        NavigationStack {
            VStack {
                VStack {

                    SubjectScrollView()

                    Spacer()
                    BackgroundScrollView()
                }
                .padding(.vertical)
                SettingsRow()
                GenerateButton()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    NavigationView {
        HybridView()
            .modelContainer(preview.container)
    }
}

#Preview {
    let preview = ContentViewContainer.init()

    NavigationView {
        HybridView()
            .modelContainer(preview.container)
    }
}
