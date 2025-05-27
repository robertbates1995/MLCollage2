//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftData
import SwiftUI

struct SubjectsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subjects: [SubjectModel]

    @State var deleteMode: Bool = false
    @Binding var subjectToEdit: SubjectModel?

    @ViewBuilder var subjectList: some View {
        ZStack {
            List {
                ForEach(subjects) { subject in
                    Section {
                        SubjectRowView(subject: subject)
                            .listRowBackground(Color.black.opacity(0.1))
                    } header: {
                        Text(subject.label)
                    }
                    .onTapGesture {
                        subjectToEdit = subject
                    }
                }
                .onDelete { indexSet in
                    let subjectsToDelete = indexSet.map({ subjects[$0] })
                    for subject in subjectsToDelete {
                        modelContext.delete(subject)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            AddButton(action: {subjectToEdit = SubjectModel(label: "default name")})
        }
    }
    
    var body: some View {
        subjectList
            .overlay {
                if subjects.isEmpty {
                    ContentUnavailableView(
                        "No Subjects",
                        systemImage: "photo",
                        description: Text(
                            "Please add a subject to continue"
                        )
                    )
                    .onTapGesture {
                        subjectToEdit = SubjectModel(
                            label: "default name"
                        )
                    }
                }
            }
            .background(
                Image(.corkBackground)
                    .opacity(0.7)
                    .ignoresSafeArea()
            )
            .sheet(item: $subjectToEdit) { subjectToEdit in
                NavigationView {
                    return EditSubjectView(subject: subjectToEdit)
                }
            }
    }
}

#Preview {
    @Previewable @State var subject: SubjectModel? = nil
    let preview = ContentViewContainer.mock

    NavigationView {
        SubjectsView(subjectToEdit: $subject)
            .modelContainer(preview.container)
    }
}
