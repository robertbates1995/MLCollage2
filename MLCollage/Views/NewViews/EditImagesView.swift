//
//  ContentView.swift
//  
//
//  Created by Robert Bates on 10/30/24.
//

import PhotosUI
import SwiftUI
import UIKit
import SwiftData

struct EditImagesView: View {
    @Environment(\.modelContext) private var modelContext
    
    var subject: SubjectModel
    let editing: Bool
    
    @Binding var selectedUUID: Set<PersistentIdentifier>

    var body: some View {
        ScrollView {
            if subject.images.isEmpty {
                Image(systemName: "photo")
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.secondary))
                Text("add images")
            } else {
                VStack {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 80))],
                        spacing: 20
                    ) {
                        ForEach(subject.images) { image in
                            if !editing {
                                NavigationLink(destination: subjectImage(image))
                                {
                                    subjectImage(image)
                                }
                            } else {
                                Button(
                                    action: {
                                        if selectedUUID.contains(
                                            image.id
                                        ) {
                                            selectedUUID.remove(
                                                image.id
                                            )
                                        } else {
                                            selectedUUID.insert(
                                                image.id
                                            )
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
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
    }

    fileprivate func subjectImage(_ image: SubjectImage) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.toImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .padding(5.0)
        }
    }

    func unSelectedImage(image: SubjectImage) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.toImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .padding(5.0)
            Image(systemName: "circle")
                .font(.title)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.accent)
                .padding(7)
        }
    }

    func selectedImage(image: SubjectImage) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.toImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .border(.accent, width: 3)
                .padding(5.0)
            Image(systemName: "checkmark.circle.fill")
                .font(.title)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .accent)
                .padding(7)
        }
    }
}

#Preview {
    @Previewable @State var subject = SubjectModel.mock
    @Previewable @State var selectedUUID: Set<PersistentIdentifier> = []
    let preview = ContentViewContainer.mock
    
    NavigationView {
        EditImagesView(subject: subject,
                       editing: false,
                       selectedUUID: $selectedUUID)
            .modelContainer(preview.container)
    }
}
