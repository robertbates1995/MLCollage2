//
//  BackgroundsView.swift
//  MLCollage
//
//  Created by Robert Bates on 3/24/25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct BackgroundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var backgrounds: [BackgroundModel]

    @State var addNewBackground: Bool = false
    @State var editing: Bool = false
    @State var selectedUUID: Set<String> = []
    @State var showConfirmation = false
    @State private var photosPickerItems: [PhotosPickerItem] = []

    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ],
                        spacing: 10
                    ) {
                        ForEach(backgrounds) { model in
                            let image = model.toMLCImage()
                            if editing {
                                Button(
                                    action: {
                                        if editing {
                                            if selectedUUID.contains(image.id) {
                                                selectedUUID.remove(image.id)
                                            } else {
                                                selectedUUID.insert(image.id)
                                            }
                                        }
                                    },
                                    label: {
                                        if selectedUUID.contains(image.id) {
                                            selectedImage(image: image)
                                        } else {
                                            unSelectedImage(image: image)
                                        }
                                    }
                                )
                            } else {
                                regularImage(image: image)
                            }
                        }
                    }
                }
                Button(
                    action: {
                        if editing {
                            selectedUUID.removeAll()
                            editing.toggle()
                        } else {
                            editing.toggle()
                        }
                    },
                    label: {
                        if editing {
                            Text("Done")
                        } else {
                            Text("Edit")
                        }
                    }
                )
                .confirmationDialog(
                    "Are you sure?",
                    isPresented: $showConfirmation
                ) {
                    Button("Remove Selected") {
                        withAnimation {
                            let items = backgrounds.filter {
                                selectedUUID.contains($0.id)
                            }
                            for item in items {
                                modelContext.delete(item)
                            }
                        }
                        editing.toggle()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Delete selected elements?")
                }
                if editing {
                    Button(
                        action: {
                            if selectedUUID.count > 0 {
                                showConfirmation.toggle()
                            }
                        },
                        label: {
                            Image(systemName: "trash")
                        }
                    )
                } else {
                    PhotosPicker(
                        "change this to a plus",
                        selection: $photosPickerItems,
                        maxSelectionCount: 10,
                        selectionBehavior: .ordered
                    )
                }
            }
        }
        .onChange(of: photosPickerItems) { _, _ in
            addImages()
        }
    }

    func addImages() {
        let localPhotosPickerItems = photosPickerItems
        photosPickerItems.removeAll()
        Task {
            for item in localPhotosPickerItems {
                if let data = try? await item.loadTransferable(
                    type: Data.self
                ) {
                    if let image = UIImage(data: data) {
                        withAnimation {
                            let newItem = BackgroundModel(
                                image: .init(uiImage: image)
                            )
                            modelContext.insert(newItem)
                        }
                    }
                }
            }
        }
    }

    func regularImage(image: MLCImage) -> some View {
        ZStack {
            Image(uiImage: image.uiImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .aspectRatio(1 / 1, contentMode: .fit)
                .clipped()
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
        }
    }

    func unSelectedImage(image: MLCImage) -> some View {
        ZStack {
            Image(uiImage: image.uiImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .aspectRatio(1 / 1, contentMode: .fit)
                .clipped()
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: "circle")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white)
                        .padding()
                }
            }
        }
    }

    func selectedImage(image: MLCImage) -> some View {
        ZStack {
            Image(uiImage: image.uiImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .aspectRatio(1 / 1, contentMode: .fit)
                .border(.blue, width: 3)
                .clipped()
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .blue)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        BackgroundsView()
            .modelContainer(for: BackgroundModel.self, inMemory: true)
    }
}
