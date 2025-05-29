//
//  SubjectRowView.swift
//  MLCollage
//
//  Created by Robert Bates on 5/2/25.
//

//
//  SubjectView 2.swift
//  MLCollage
//
//  Created by Robert Bates on 3/22/25.
//

//
//  ContentView.swift
//  suygfshiudrhiu
//
//  Created by Robert Bates on 10/30/24.
//

import PhotosUI
import SwiftData
import SwiftUI
import UIKit

struct SubjectRowView: View {
    let subject: SubjectModel
    let size: CGFloat = 100.0

    var body: some View {
        VStack {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: size))],
                spacing: 20
            ) {
                ForEach(subject.images, id: \.self) { image in
                    subjectImage(image)
                        .shadow(radius: 5.0)
                }
            }
            Spacer()
        }
    }

    fileprivate func subjectImage(_ image: SubjectImage) -> some View {
        Image(uiImage: image.toImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
        //            .background(.black.opacity(0.3))
        //            .cornerRadius(size / 10)
    }
}

#Preview {
    let imageModel = SubjectImage(
        image: UIImage(resource: .robotWithScissors),
        subject: SubjectModel(label: "test1")
    )
    
    let imageModel2 = SubjectImage(
        image: UIImage(resource: .folderTab),
        subject: SubjectModel(label: "test2")
    )
    
    NavigationView {
        SubjectRowView(
            subject: SubjectModel(label: "Test Subject", images: [imageModel, imageModel2])
        )
    }
}
