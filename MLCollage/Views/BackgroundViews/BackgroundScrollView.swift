//
//  BackgroundScrollView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/3/25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct BackgroundScrollView: View {
    @Environment(\.modelContext) private var modelContext
    @State var editingBackgrounds: Bool = false
    @Query private var backgrounds: [BackgroundModel]
    @State private var backgroundsPhotosPickerItems: [PhotosPickerItem] = []
    @State var selectedBackgroundUUID: Set<PersistentIdentifier> = []

    fileprivate func removeSelected() {
        do {
            try modelContext.delete(
                model: BackgroundModel.self,
                where: #Predicate { background in
                    selectedBackgroundUUID.contains(background.id)
                }
            )
        } catch {
            print("Failed to delete objects based on predicate: \(error)")
        }
        try? modelContext.save()
    }

    var body: some View {
        HStack {
            Text("Backgrounds")
                .font(.headline)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                if editingBackgrounds {
                    selectedBackgroundUUID.removeAll()
                }
                editingBackgrounds.toggle()
            }) {
                Text(editingBackgrounds ? "done" : "edit")
            }
            if editingBackgrounds {
                Button(action: { removeSelected() }) {
                    Image(systemName: "trash")
                }
            } else {
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
                        if editingBackgrounds {
                            Button(action: {
                                if selectedBackgroundUUID.contains(
                                    background.id
                                ) {
                                    selectedBackgroundUUID.remove(background.id)
                                } else {
                                    selectedBackgroundUUID.insert(background.id)
                                }
                            }) {
                                backgroundImage(background)
                                    .selectedOverlay(
                                        selectedBackgroundUUID.contains(
                                            background.id
                                        )
                                    )
                            }
                        } else {
                            backgroundImage(background)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding(.horizontal)
        }
    }

    fileprivate func backgroundImage(_ background: BackgroundModel) -> some View
    {
        return Image(uiImage: background.toMLCImage().uiImage)
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

#Preview {
    let preview = ContentViewContainer.mock

    NavigationView {
        VStack {
            BackgroundScrollView()
                .modelContainer(preview.container)
                .frame(height: 100)
        }
    }
}
