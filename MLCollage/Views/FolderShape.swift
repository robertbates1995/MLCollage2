//
//  addButton.swift
//  MLCollage
//
//  Created by Robert Bates on 5/27/25.
//

import SwiftUI

struct FolderShape: View {
    let title: String = "Default Title"
    let subjectRowView: SubjectRowView

    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20.0, height: 20.0))
            VStack {
                HStack {
                    Text(title)
                        .colorInvert()
                        .font(.title)
                        .padding([.leading, .top])
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(
                        cornerSize: CGSize(width: 20.0, height: 20.0)
                    )
                    .fill(Color.gray)
                    subjectRowView
                        .padding()
                }
            }
        }
        //TODO: REMOVE THIS PADDING WHEN DONE
        .padding()
    }
}

#Preview {
    let subjectRowView = SubjectRowView(subject: SubjectModel.mock)
    
    FolderShape(subjectRowView: subjectRowView)
}
