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
    
    @State var selectedUUID: Set<PersistentIdentifier> = []

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

    fileprivate func subjectImage(_ image: SubjectImageModel) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.toImage())
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
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
        }
    }

    func unSelectedImage(image: SubjectImageModel) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.toImage())
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
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
            Image(systemName: "circle")
                .font(.title)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white)
                .padding(7)
        }
    }

    func selectedImage(image: SubjectImageModel) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.toImage())
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
                .border(.blue, width: 3)
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
            Image(systemName: "checkmark.circle.fill")
                .font(.title)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue)
                .padding(7)
        }
    }
}
