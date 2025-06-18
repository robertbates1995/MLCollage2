//
//  HybridView.swift
//  MLCollage
//
//  Created by Robert Bates on 6/17/25.
//

import SwiftData
import SwiftUI

struct HybridView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subjects: [SubjectModel]
    @Query private var backgrounds: [BackgroundModel]

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(subjects) { subject in
                    HeroView(images: subject.images)
                        .frame(width: 200, height: 200)
                        .background(.red) //TODO: REMOVE BACKGROUND
                }
            }
        }
    }
}

#Preview {
    let preview = ContentViewContainer()

    NavigationView {
        HybridView()
            .modelContainer(preview.container)
    }
}
