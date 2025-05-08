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
    @State var editSubjectMode: Bool = false
    @State var subjectToEdit: SubjectModel = SubjectModel(
        label: "this is a special word"
    )
    @State var showConfirmation = false
    
    @ViewBuilder var subjectList: some View {
        List {
            ForEach(subjects) { subject in
                Section {
                    HStack(spacing: 10) {
                        SubjectRowView(subject: subject)
                    }
                } header: {
                    Text(subject.label)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                }
                .contentShape(.rect())
                .onTapGesture {
                    subjectToEdit = subject
                    editSubjectMode.toggle()
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

    var body: some View {
        NavigationView {
            List {
                ForEach(subjects) { subject in
                    Section {
                        HStack(spacing: 10) {
                            SubjectRowView(subject: subject)
                        }
                    } header: {
                        Text(subject.label)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipped()
                    }
                    .contentShape(.rect())
                    .onTapGesture {
                        subjectToEdit = subject
                        editSubjectMode.toggle()
                    }
                }
                .onDelete { indexSet in
                    let subjectsToDelete = indexSet.map({ subjects[$0] })
                    for subject in subjectsToDelete {
                        modelContext.delete(subject)
                    }
                }
            }
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
                        subjectToEdit = SubjectModel(label: "default name")
                        editSubjectMode.toggle()
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Remove all") {
                        showConfirmation = true
                    }
                    .confirmationDialog(
                        "Are you sure?",
                        isPresented: $showConfirmation
                    ) {
                        Button("Remove all") {
                            //TODO: clearAll()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("This action cannot be undone.")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            subjectToEdit = SubjectModel(label: "default name")
                            editSubjectMode.toggle()
                        },
                        label: {
                            Image(systemName: "plus")
                        }
                    )
                }
            }
            .sheet(
                isPresented: $editSubjectMode,
                onDismiss: didDismiss
            ) {
                NavigationView {
                    EditSubjectView(subject: subjectToEdit)
                }
            }
            .navigationTitle("Subjects")
            //.foregroundColor(.accent)
        }
    }

    func didDismiss() {
        //add(subject: newSubject)
    }
}

#Preview {
    let preview = ContentViewContainer()

    NavigationView {
        SubjectsView()
            .modelContainer(preview.container)
    }
}
