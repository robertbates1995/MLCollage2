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
            VStack(spacing: 16) {
                VStack {
                    SubjectScrollView()
                }
                .frame(maxHeight: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                VStack {
                    BackgroundScrollView()
                }
                .frame(maxHeight: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                VStack(spacing: 12) {
                    SettingsRow()
                    GenerateButton()
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)
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
