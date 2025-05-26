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
    @State var subjectToEdit: (SubjectModel?) = nil
    @State var showConfirmation = false
    
    @ViewBuilder var subjectList: some View {
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
        .onChange(of: subjectToEdit) {
            if subjectToEdit != nil {
                editSubjectMode = true
            }
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
                                subjectToEdit = SubjectModel(
                                    label: "default name"
                                )
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
                    if let subjectToEdit {
                        NavigationView {
                            return EditSubjectView(subject: subjectToEdit)
                        }
                    }
                }
        
    }

    func didDismiss() {
        self.subjectToEdit = nil
    }
}

#Preview {
    let preview = ContentViewContainer()

    NavigationView {
        SubjectsView()
            .modelContainer(preview.container)
    }
}
