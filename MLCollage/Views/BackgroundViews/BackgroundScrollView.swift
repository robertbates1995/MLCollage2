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

    var body: some View {
        HStack {
            Text("Backgrounds")
                .font(.headline)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                editingBackgrounds.toggle()
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
}
