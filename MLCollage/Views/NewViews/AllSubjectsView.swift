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
    
    @State var subjectToEdit: SubjectModel? = nil

    var body: some View {
        List {
            ForEach(subjects) { subject in
                SubjectRowView(subject: subject)
                    .listRowInsets(EdgeInsets())
            }
            .onDelete { indexSet in
                let subjectsToDelete = indexSet.map({ subjects[$0] })
                for subject in subjectsToDelete {
                    modelContext.delete(subject)
                }
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add"){
                    subjectToEdit = SubjectModel(label: "New Subject")
                }
            }
        }
        .sheet(item: $subjectToEdit) { subjectToEdit in
            NavigationView {
                return SubjectDetailView(subject: subjectToEdit)
            }
        }
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    NavigationView {
        AllSubjectsView()
            .modelContainer(preview.container)
    }
}
