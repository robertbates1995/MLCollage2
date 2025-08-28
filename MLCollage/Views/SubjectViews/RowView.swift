//
//  SubjecgtRowView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/3/25.
//

import SwiftUI

struct SubjectRowView: View {
    let subject: SubjectModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(subject.label)")
            HStack {
                Image(uiImage: subject.images[0].toImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity, height: 100)
            }
        }
        .padding()
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    SubjectRowView(subject: SubjectModel.mock1)
        .modelContainer(preview.container)
}
