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
    var editing: Bool
    @State var selectedUUID: Set<String> = []
    @State var showConfirmation = false
    @State private var photosPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        ZStack {
            BackgroundsScrollView
                .mask(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .black, .black, .black, .black, .black,
                            .black, .black, .black, .black, .black,
                            .black, .black, .black, .black, .black,
                            .black, .black, .black, .black, .black,
                            .black, .black, .black, .black, .black,
                            .clear, .clear,]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .ignoresSafeArea()
                )
            ButtonsOverlay
        }
        .background(
            Image(.corkBackground)
                .opacity(0.8)
                .ignoresSafeArea()
        )
        .onChange(of: photosPickerItems) { _, _ in
            addImages()
        }
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
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Delete selected elements?")
        }
    }

    @ViewBuilder var BackgroundsScrollView: some View {
        ScrollView {
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
    }

    @ViewBuilder var ButtonsOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                if editing {
                    Button(
                        action: {
                            if selectedUUID.count > 0 {
                                showConfirmation.toggle()
                            }
                        },
                        label: {
                            Image(systemName: "trash.circle.fill")
                                .resizable()
                                .frame(width: 80.0, height: 80.0)
                                .accentColor(Color.red)
                        }
                    )
                    .padding(
                        EdgeInsets(
                            top: 0.0,
                            leading: 0.0,
                            bottom: 20.0,
                            trailing: 40.0
                        )
                    )
                } else {
                    PhotosPicker(
                        selection: $photosPickerItems,
                        maxSelectionCount: 10,
                        selectionBehavior: .ordered
                    ) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                    }
                    .padding(
                        EdgeInsets(
                            top: 0.0,
                            leading: 0.0,
                            bottom: 20.0,
                            trailing: 40.0
                        )
                    )
                }
            }
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
        BackgroundsView(editing: false)
            .modelContainer(for: BackgroundModel.self, inMemory: true)
    }
}
