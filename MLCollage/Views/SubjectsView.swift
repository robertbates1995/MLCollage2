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
                    let title = {
                        subject.images.isEmpty
                            ? "\(subject.label) (invalid)" : subject.label
                    }()
                    Section {
                        SubjectFolderView(
                            title: title,
                            subjectRowView: SubjectRowView(subject: subject)
                        )
                    }
                    .listRowInsets(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    .listRowBackground(Color.clear)
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
            .background(Color(.secondarySystemBackground))
            .scrollContentBackground(.hidden)
            AddButton(action: {
                let subject = SubjectModel(label: "default name")
                modelContext.insert(subject)
                try? modelContext.save()
                subjectToEdit = subject
            })
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
                    .foregroundStyle(.accent)
                    .onTapGesture {
                        subjectToEdit = SubjectModel(
                            label: "default name"
                        )
                    }
                }
            }
            .sheet(item: $subjectToEdit) { subjectToEdit in
                NavigationView {
                    return EditSubjectView(subject: subjectToEdit)
                }
            }
    }
}

#Preview {
    @Previewable @State var subject: SubjectModel? = nil
    let preview = ContentViewContainer()

    NavigationView {
        SubjectsView(subjectToEdit: $subject)
            .modelContainer(preview.container)
    }
}
