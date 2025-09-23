//
//  GenerateButton.swift
//  MLCollage
//
//  Created by Robert Bates on 9/3/25.
//

import SwiftData
import SwiftUI

struct GenerateButton: View {
    @Environment(\.modelContext) private var modelContext
    @State var output: OutputModel = OutputModel()
    @Query private var subjects: [SubjectModel]
    @Query private var backgrounds: [BackgroundModel]

    var body: some View {
        NavigationLink(
            destination: {
                return OutputsView(model: $output)
            }
        ) {
            HStack {
                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)

                Spacer()

                VStack(spacing: 2) {
                    Text("Generate Results")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Text("Process your data and create output")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.accent, .accent.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 16,
                    topTrailingRadius: 0
                )
            )
            .shadow(color: .accent.opacity(0.3), radius: 8, x: 0, y: 4)
            .opacity(isLinkReady() ? 1.0 : 0.6)
            .animation(.easeInOut(duration: 0.2), value: isLinkReady())
        }
        .disabled(!isLinkReady())
        .onAppear {
            if output.modelContext == nil {
                output.modelContext = modelContext
            }
        }
    }

    func isLinkReady() -> Bool {
        if subjects.isEmpty || backgrounds.isEmpty {
            return false
        }
        return true
    }
}
