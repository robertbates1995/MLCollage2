//
//  SubjectScrollView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/3/25.
//

import SwiftData
import SwiftUI

struct SubjectScrollView: View {
    @Environment(\.modelContext) private var modelContext
    @State var editingSubjects: Bool = false
    @State var subjectToEdit: SubjectModel? = nil
    @Query private var subjects: [SubjectModel]
    @State var selectedSubjectUUID: Set<PersistentIdentifier> = []
    
    var body: some View {
        HStack {
            Text("Subjects")
                .font(.headline)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                editingSubjects.toggle()
            }) {
                Text(editingSubjects ? "done" : "edit")
            }
            Button(action: {
                let subject = SubjectModel(label: "default name")
                modelContext.insert(subject)
                try? modelContext.save()
                subjectToEdit = subject
            }) {
                Image(systemName: "plus")
            }
            .padding(.horizontal)
            .padding(.vertical, 2.0)
            .background(.black.opacity(0.05))
            .clipShape(.rect(cornerRadius: 15.0))
            .padding(.horizontal)
        }
        .sheet(item: $subjectToEdit, onDismiss: {}) { subjectToEdit in
            NavigationView {
                SubjectDetailView(subject: subjectToEdit)
            }
        }
        if subjects.isEmpty {
            HStack {
                ContentUnavailableView(
                    "No Subjects",
                    systemImage: "photo",
                    description: Text(
                        "At lest one subject is needed"
                    )
                )
            }
        } else {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(subjects) { subject in
                        if !editingSubjects {
                            NavigationLink(destination: {
                                SubjectDetailView(subject: subject)
                            }) {
                                HeroView(subject: subject)
                            }
                        } else {
                            Button(action: {}) {
                                HeroView(subject: subject)
                                    .selectedOverlay(false)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    NavigationView {
        VStack {
            SubjectScrollView()
                .modelContainer(preview.container)
        }
    }
}
