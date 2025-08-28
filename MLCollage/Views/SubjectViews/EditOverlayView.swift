//
//  EditOverlayView.swift
//  MLCollage
//
//  Created by Robert Bates on 8/27/25.
//

import SwiftUI

func subjectImage(_ image: SubjectImage) -> some View {
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
