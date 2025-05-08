//
//  NewSubjectView.swift
//  MLCollage
//
//  Created by Robert Bates on 11/4/24.
//

import PhotosUI
import SwiftUI

struct EditSubjectView: View {
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
        modelContext.insert(SubjectImageModel(image: image, subject: subject))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Label: ")
                TextField("new subject", text: Bindable(subject).label)
                    .padding()
                    .background(Color.black.opacity(0.1))
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
            ToolbarItem(placement: .navigationBarLeading) {
                if subject.images.isEmpty {
                    Text("Edit")
                        .foregroundStyle(.black.opacity(0.5))
                } else {
                    Button(editing ? "Done" : "Edit") {
                        withAnimation { editing.toggle() }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                PhotosPicker(
                    selection: $photosPickerItems,
                    maxSelectionCount: 10,
                    selectionBehavior: .ordered
                ) {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editing ? "Delete" : "Save") {
                    if editing {
                        dismiss()
                    } else {
                        modelContext.insert(subject)
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
        //.foregroundColor(.accent)
    }
}
