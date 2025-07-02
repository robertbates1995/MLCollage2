//
//  AllBackgroundsView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/1/25.
//

import SwiftData
import SwiftUI

struct AllBackgroundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var backgrounds: [BackgroundModel]
    
    var body: some View {
        Grid {
            ForEach(backgrounds) { background in
                Image(uiImage: background.toMLCImage().uiImage)
                    .resizable()
                    .clipShape(.rect(cornerRadius: 10.0))
                    .frame(maxWidth: 100, maxHeight: 100)
                    .padding(3.0)
            }
        }
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    AllBackgroundsView()
        .modelContainer(preview.container)
}
