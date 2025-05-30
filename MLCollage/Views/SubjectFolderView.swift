//
//  addButton.swift
//  MLCollage
//
//  Created by Robert Bates on 5/27/25.
//

import SwiftUI

struct SubjectFolderView: View {
    let title: String
    let subjectRowView: SubjectRowView

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(title)
                .colorInvert()
                .font(.title)
                .padding([.leading, .top, .trailing])
                .background(
                    UnevenRoundedRectangle(
                        cornerRadii: RectangleCornerRadii(
                            topLeading: 10.0,
                            topTrailing: 10.0
                        )
                    )
                    .fill(Color.gray)
                )
            subjectRowView
                .padding()
                .background(
                    UnevenRoundedRectangle(
                        cornerRadii: RectangleCornerRadii(
                            bottomLeading: 10.0,
                            bottomTrailing: 10.0,
                            topTrailing: 10.0
                        )
                    )
                    .fill(Color.gray)
                )
        }
        .background(RoundedRectangle(cornerRadius: 10.0))
    }
}

#Preview {
    let subjectRowView = SubjectRowView(subject: SubjectModel.mock)

    SubjectFolderView(title: "Preview Title", subjectRowView: subjectRowView)
}
