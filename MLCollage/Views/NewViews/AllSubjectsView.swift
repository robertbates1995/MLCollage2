//
//  AllSubjectsView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/1/25.
//

import SwiftData
import SwiftUI

struct AllSubjectsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subjects: [SubjectModel]
    
    var body: some View {
        List {
            ForEach(subjects) { subject in
                Section {
                    HeroView(subject: subject)
                }
            }
            .onDelete { indexSet in
                let subjectsToDelete = indexSet.map({ subjects[$0] })
                for subject in subjectsToDelete {
                    modelContext.delete(subject)
                }
            }
        }
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    AllSubjectsView()
        .modelContainer(preview.container)
}
