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
        ScrollView {
            LazyVGrid(columns: [
                .init(.adaptive(minimum: 100, maximum: .infinity))
            ]) {
                ForEach(backgrounds) { background in
                    Image(uiImage: background.toMLCImage().uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity
                        )
                        .clipped()
                }
            }
        }
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    AllBackgroundsView()
        .modelContainer(preview.container)
}
