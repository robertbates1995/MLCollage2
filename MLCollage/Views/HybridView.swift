//
//  HybridView.swift
//  MLCollage
//
//  Created by Robert Bates on 6/17/25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct HybridView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subjects: [SubjectModel]
    @Query private var backgrounds: [BackgroundModel]
    @State private var backgroundsPhotosPickerItems: [PhotosPickerItem] = []
    @State var deleteMode: Bool = false
    @State var subjectToEdit: SubjectModel? = nil
    @State var editingSubjects = false
    @State var editingBackgrounds = false

    @State var title: String = "Test Title"
    let backgroundColor: Color = Color(UIColor.secondarySystemBackground)
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    VStack {
                        subjectScrollView
                    }
                    .frame(height: 170.0)
                    .padding(.vertical)
                    .background(Color.secondaryAccent)
                    .clipShape(.rect(cornerRadius: 15.0))
                    .shadow(radius: 5.0)
                    Spacer()
                    backgroundScrollView
                }
                .padding(.vertical)
                settingsView
                GenerateButton(subjects: subjects, backgrounds: backgrounds)
            }
            .ignoresSafeArea(edges: .bottom)
            .sheet(item: $subjectToEdit, onDismiss: {}) { subjectToEdit in
                NavigationView {
                    SubjectDetailView(subject: subjectToEdit)
                }
            }
        }
    }

   
    
    @ViewBuilder var subjectScrollView: some View {
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
                            HeroView(subject: subject)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder var backgroundScrollView: some View {
        HStack {
            Text("Backgrounds")
                .font(.headline)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                editingSubjects.toggle()
            }) {
                Text(editingBackgrounds ? "done" : "edit")
            }
            PhotosPicker(
                selection: $backgroundsPhotosPickerItems,
                maxSelectionCount: 10,
                selectionBehavior: .ordered
            ) {
                Image(systemName: "plus")
                    .padding(.horizontal)
                    .padding(.vertical, 2.0)
                    .background(.black.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 15.0))
                    .padding(.horizontal)
            }
            .onChange(of: backgroundsPhotosPickerItems) { _, _ in
                let localPhotosPickerItems = backgroundsPhotosPickerItems
                backgroundsPhotosPickerItems.removeAll()
                Task {
                    for item in localPhotosPickerItems {
                        if let data = try? await item.loadTransferable(
                            type: Data.self
                        ) {
                            if let image = UIImage(data: data) {
                                modelContext.insert(
                                    BackgroundModel(
                                        image: MLCImage(uiImage: image)
                                    )
                                )
                                try? modelContext.save()
                            }
                        }
                    }
                }
            }
        }
        if backgrounds.isEmpty {
            HStack {
                ContentUnavailableView(
                    "No Backgrounds",
                    systemImage: "photo",
                    description: Text(
                        "At lest one background is needed"
                    )
                )
            }
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(backgrounds) { background in
                        Image(uiImage: background.toMLCImage().uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                maxWidth: .greatestFiniteMagnitude,
                                maxHeight: .greatestFiniteMagnitude
                            )
                            .clipShape(.rect(cornerRadius: 8.0))
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                maxWidth: .greatestFiniteMagnitude,
                                maxHeight: .greatestFiniteMagnitude
                            )
                            .padding(3.0)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding(.horizontal)
        }
    }

    @ViewBuilder var settingsView: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding([.horizontal, .top])
            VStack {
                SettingsViewWrapper()
            }
            .background(.white.opacity(0.05))
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: RectangleCornerRadii(
                        topLeading: 10.0,
                        bottomLeading: 30.0,
                        bottomTrailing: 30.0,
                        topTrailing: 10.0
                    )
                )
            )
            .foregroundStyle(.app)
            .padding([.horizontal, .bottom], 15.0)
        }
        .background(.accent)
        .clipShape(.rect(cornerRadius: 10.0))
        .foregroundStyle(.app)
        .shadow(radius: 5.0)
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    NavigationView {
        HybridView()
            .modelContainer(preview.container)
    }
}

#Preview {
    let preview = ContentViewContainer.init()

    NavigationView {
        HybridView()
            .modelContainer(preview.container)
    }
}

//________//

struct GenerateButton: View {
    @Environment(\.modelContext) private var modelContext
    @State var output: OutputModel = OutputModel()
    let subjects: [SubjectModel]
    let backgrounds: [BackgroundModel]

    var body: some View {
        NavigationLink(
            "Generate Results",
            destination: {
                return OutputsView(model: $output)
            }
        )
        .disabled(!isLinkReady())
        .padding()
        .onAppear {
            if output.modelContext == nil {
                output.modelContext = modelContext
            }
        }
    }
    
    func isLinkReady() -> Bool {
        if subjects.isEmpty || backgrounds.isEmpty {
            return false
        }
        return true
    }
}
