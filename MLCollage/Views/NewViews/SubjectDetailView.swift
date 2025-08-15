//
//  NewSubjectView.swift
//  MLCollage
//
//  Created by Robert Bates on 11/4/24.
//

import PhotosUI
import SwiftData
import SwiftUI

struct SubjectDetailView: View {
    @Environment(\.modelContext) private var modelContext

    var subject: SubjectModel

    @State private var editing = false
    @State private var isPresented: Bool = false

    @Environment(\.dismiss) var dismiss

    private static let initialColumns = 3
    @State private var numColumns = initialColumns
    @State private var gridColumns = Array(
        repeating: GridItem(.flexible()),
        count: initialColumns
    )

    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State var selectedUUID: Set<PersistentIdentifier> = []

    func addImage(_ image: UIImage) {
        modelContext.insert(SubjectImage(image: image, subject: subject))
        try? modelContext.save()
    }

    var body: some View {
        VStack {
            HStack {
                Text("Label: ")
                TextField("new subject", text: Bindable(subject).label)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .onChange(of: subject.label) {
                        try? modelContext.save()
                    }
            }
            if subject.images.isEmpty {
                PhotosPicker(
                    selection: $photosPickerItems,
                    maxSelectionCount: 10,
                    selectionBehavior: .ordered
                ) {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.secondary))
                            Text("add images")
                        }
                        .padding()
                        Spacer()
                    }
                }
            } else {
                EditImagesView(
                    subject: subject,
                    editing: editing,
                    selectedUUID: $selectedUUID
                )
            }
            Spacer()
        }
        .padding()
        .onChange(of: photosPickerItems) { _, _ in
            let localPhotosPickerItems = photosPickerItems
            photosPickerItems.removeAll()
            Task {
                for item in localPhotosPickerItems {
                    if let data = try? await item.loadTransferable(
                        type: Data.self
                    ) {
                        if let image = UIImage(data: data) {
                            addImage(image)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if subject.images.isEmpty {
                    Text("Edit")
                        .foregroundStyle(.black.opacity(0.5))
                } else {
                    Button(editing ? "Done" : "Edit") {
                        withAnimation { editing.toggle() }
                    }
                }
            }
            if !editing {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(
                        selection: $photosPickerItems,
                        maxSelectionCount: 10,
                        selectionBehavior: .ordered
                    ) {
                        Image(systemName: "plus")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    editing
                        ? "Remove"
                        : { subject.images.isEmpty ? "Add" : "Save" }()
                ) {
                    if editing {
                        editButtonPressed()
                        editing.toggle()
                    } else {
                        if subjectIsValid() {
                            saveButtonPressed()
                        } else {
                            isPresented.toggle()
                        }
                    }
                }
                .alert(
                    "Are You Sure?",
                    isPresented: $isPresented,
                    actions: {
                        /// A destructive button that appears in red
                        Button(role: .destructive) {
                            modelContext.delete(subject)
                            try? modelContext.save()
                            dismiss()
                        } label: {
                            Text("Delete and Return")
                        }
                        /// A cancellation button that appears with bold text.
                        Button("Continue Editing", role: .cancel) {
                            /// Perform cancellation
                            isPresented.toggle()
                        }
                    },
                    message: {
                        Text(
                            "A subject without an image\nand/or label cannot be saved"
                        )
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            //Also fires when the sheet goes away
            if !savePressed {
                print("Sheet disappeared")
                saveButtonPressed()
            }
        }
    }
    
    func leaving() {
        //handle all cases of exiting sheet
        //case 1: save is pressed
            //sub-case: subject is valid
            //sub-case: subject is not valid
                //starts from the alert?
        //case 2: sheet is swiped down
        //sub-case: subject is valid
        //sub-case: subject is not valid
    }
    
    func subjectIsValid() -> Bool {
        if subject.images.isEmpty || subject.label.isEmpty {
            return false
        }
        return true
    }

    func editButtonPressed() {
        if editing {
            for image in subject.images {
                if selectedUUID.contains(image.id) {
                    modelContext.delete(image)
                }
            }
            try? modelContext.save()
        }
    }

    func saveButtonPressed() {
        if subjectIsValid() {
            modelContext.insert(subject)
            try? modelContext.save()
            dismiss()
        } else {
            modelContext.delete(subject)
            try? modelContext.save()
        }
    }
}

#Preview {
    @Previewable @State var subject = SubjectModel.mock
    let preview = ContentViewContainer.mock

    NavigationView {
        SubjectDetailView(subject: subject)
            .modelContainer(preview.container)
    }
}
