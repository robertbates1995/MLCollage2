//
//  HeroView.swift
//  MLCollage
//
//  Created by Robert Bates on 6/18/25.
//

import SwiftData
import SwiftUI

struct HeroView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subject: [SubjectModel]
    
    var body: some View {
        let depth: Range<Int> = {0..<min(subject[0].images.count, 4)}()
        
        ZStack {
            ForEach(depth) { depth in
                subject[0].images[depth]
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(3.0)
                    .background(.black.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 20.0))
                    .offset(x: CGFloat(depth) * 5, y: CGFloat(depth) * 5)
            }
        }
    }
}



#Preview {
    @Previewable @State var subject: SubjectModel? = nil
    let preview = ContentViewContainer.mock
    
    HeroView()
        .modelContainer(preview.container)
}
