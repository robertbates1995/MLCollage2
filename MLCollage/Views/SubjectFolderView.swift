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
        ZStack {
            RoundedRectangle(
                cornerSize: CGSize(width: 10.0, height: 10.0)
            )
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
                ZStack {
                    UnevenRoundedRectangle(
                        cornerRadii: RectangleCornerRadii(
                            bottomLeading: 10.0,
                            bottomTrailing: 10.0,
                            topTrailing: 10.0
                        )
                    )
                    .fill(Color.gray)
                    subjectRowView
                        .padding()
                }
            }
        }
    }
}

#Preview {
    let subjectRowView = SubjectRowView(subject: SubjectModel.mock)

    SubjectFolderView(title: "Preview Title", subjectRowView: subjectRowView)
}
