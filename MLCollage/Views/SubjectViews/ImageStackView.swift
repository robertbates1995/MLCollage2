//
//  HeroView.swift
//  MLCollage
//
//  Created by Robert Bates on 6/18/25.
//

import SwiftUI

struct HeroView: View {
    let subject: SubjectModel
    
    var body: some View {
        let zipped = Array(zip(subject.images, 0..<4))
        let count = zipped.count
        let start = 100 - count * 5
        
        VStack{
            ZStack {
                ForEach(zipped, id: \.0) { image, depth in
                    Image(uiImage: image.toImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(start + depth * 5),
                               height: CGFloat(start + depth * 5))
                        .blur(radius: CGFloat(count - depth - 1) * 2)
                }
            }
        }
    }
}

#Preview {
    HeroView(subject: SubjectModel.mock)
}
