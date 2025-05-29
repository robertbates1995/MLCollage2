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
                    let title = {subject.images.isEmpty ? "\(subject.label) (invalid)" : subject.label}()
                    SubjectFolderView(title: title,
                                      subjectRowView: SubjectRowView(subject: subject))
                    .onTapGesture {
                        subjectToEdit = subject
                    }
//                        ZStack {
//                            Image(.folderTab)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                            VStack {
//                                if subject.images.isEmpty {
//                                    Text("\(subject.label) (invalid)")
//                                        .foregroundColor(.red)
//                                        .font(.headline)
//                                        .padding()
//                                } else {
//                                    Text(subject.label)
//                                        .foregroundColor(.black)
//                                        .font(.headline)
//                                        .opacity(0.8)
//                                        .padding()
//                                }
//                                Spacer()
//                            }
//                        }
                }
                .onDelete { indexSet in
                    let subjectsToDelete = indexSet.map({ subjects[$0] })
                    for subject in subjectsToDelete {
                        modelContext.delete(subject)
                    }
                }
            }
            .shadow(radius: 20.0)
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
                    .onTapGesture {
                        subjectToEdit = SubjectModel(
                            label: "default name"
                        )
                    }
                }
            }
            .background(
                Image(.corkBackground)
                    .opacity(0.8)
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
