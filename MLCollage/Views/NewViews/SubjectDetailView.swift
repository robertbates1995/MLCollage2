//
//  NewSubjectView.swift
//  MLCollage
//
//  Created by Robert Bates on 11/4/24.
//

import PhotosUI
import SwiftUI

struct SubjectDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    var subject: SubjectModel
    
    @State private var editing = false
    @Environment(\.dismiss) var dismiss

    private static let initialColumns = 3
    @State private var numColumns = initialColumns
    @State private var gridColumns = Array(
        repeating: GridItem(.flexible()),
        count: initialColumns
    )
    
    @State private var photosPickerItems: [PhotosPickerItem] = []

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
                EditImagesView(subject: subject, editing: editing)
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
                Button(editing ? "Delete" : "Save") {
                    if editing {
                        //TODO: get delete to work
                        dismiss()
                    } else {
                        modelContext.insert(subject)
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
