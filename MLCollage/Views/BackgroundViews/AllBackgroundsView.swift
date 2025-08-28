//
//  AllBackgroundsView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/1/25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct AllBackgroundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var backgrounds: [BackgroundModel]
    @State private var photosPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                .init(.adaptive(minimum: 100, maximum: .infinity))
            ]) {
                ForEach(backgrounds) { background in
                    Image(uiImage: background.toMLCImage().uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity
                        )
                        .clipped()
                }
            }
        }
        .toolbar {
            PhotosPicker(
                selection: $photosPickerItems,
                maxSelectionCount: 10,
                selectionBehavior: .ordered
            ) {
                Image(systemName: "plus")
                    .resizable()
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
}

#Preview {
    let preview = ContentViewContainer.mock

    NavigationView {
        AllBackgroundsView()
            .modelContainer(preview.container)
    }
}
