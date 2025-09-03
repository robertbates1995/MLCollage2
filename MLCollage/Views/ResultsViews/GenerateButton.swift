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
            "Generate Results",
            destination: {
                return OutputsView(model: $output)
            }
        )
        .disabled(!isLinkReady())
        .padding()
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
