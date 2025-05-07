//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI
import SwiftData

struct SubjectsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subjects: [SubjectModel]
    
    @State var addNewSubject: Bool = false
    @State var addNewBackground: Bool = false
    @State var editSubject: Bool = false
    @State var newSubject: SubjectModel?
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
                    newSubject = subject
                    addNewSubject.toggle()
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
            subjectList
            .overlay {
                if subjects.isEmpty {
                    ContentUnavailableView(
                        "No Subjects",
                        systemImage: "photo",
                        description: Text("Please add a subject to continue")
                    )
                    .onTapGesture {
                        addNewSubject.toggle()
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Remove all") {
                        showConfirmation = true
                    }
                    .confirmationDialog(
                        "Are you sure?", isPresented: $showConfirmation
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
                            addNewSubject.toggle()
                        },
                        label: {
                            Image(systemName: "plus")
                        })
                }
            }
            .sheet(
                isPresented: $addNewSubject,
                onDismiss: didDismiss
            ) {
                NavigationView {
                    EditSubjectView(subject: newSubject!)
                }
            }
            .sheet(
                isPresented: $addNewBackground
            ) {
                NavigationView {
                    //EditBackgroundView(backgrounds: backgrounds)
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
    let preview = SettingsPreviewContainer()
    
    NavigationView {
        SubjectsView()
            .modelContainer(preview.container)
    }
}

@MainActor
struct SubjectsPreviewContainer {
    let container: ModelContainer
    init() {
        do {
            container = try ModelContainer(for: SettingsModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            container.mainContext.insert(SettingsModel())
        } catch {
            fatalError()
        }
    }
    
}
