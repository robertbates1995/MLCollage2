//
//  HybridView.swift
//  MLCollage
//
//  Created by Robert Bates on 6/17/25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct CardStyle: ViewModifier {
    let intensity: CardIntensity
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.accent, lineWidth: 1.0)
                    .opacity(intensity.opacity)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

enum CardIntensity {
    case light, medium, strong
    
    var borderWidth: CGFloat {
        switch self {
        case .light: return 0.5
        case .medium: return 1.0
        case .strong: return 1.5
        }
    }

    var opacity: Double {
        switch self {
        case .light: return 0.2
        case .medium: return 0.4
        case .strong: return 0.6
        }
    }
}

extension View {
    func cardStyle(_ intensity: CardIntensity = .medium) -> some View {
        modifier(CardStyle(intensity: intensity))
    }
}

struct HybridView: View {
    @State var title: String = "Test Title"
    let backgroundColor: Color = Color(UIColor.secondarySystemBackground)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    VStack {
                        SubjectScrollView()
                    }
                    .frame(maxHeight: .infinity)
                    .cardStyle(.strong)

                    VStack {
                        BackgroundScrollView()
                    }
                    .frame(maxHeight: .infinity)
                    .cardStyle(.strong)

                    VStack {
                        SettingsRow()
                    }
                    .cardStyle(.strong)
                }
                .padding(.horizontal, 8)

                GenerateButton()
                    .padding(.top, 16)
            }
            .background(Color(.secondarySystemBackground))
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
