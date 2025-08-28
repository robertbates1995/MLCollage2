//
//  ThumbnailView.swift
//  MLCollage
//
//  Created by Robert Bates on 1/10/25.
//

import SwiftUI

@Observable
class ThumbnailCache {
    @ObservationIgnored var cache: UIImage?
    var size: CGFloat = 10.0

    nonisolated
    func thumbnail(from source: Collage) async -> UIImage {

        if let cache, cache.size.width == size, cache.size.height == size {
            return cache
        }

        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size, height: size), true, 1.0)
        source.previewImage.draw(
            in: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        defer { UIGraphicsEndImageContext() }
        cache = UIGraphicsGetImageFromCurrentImageContext()

        return cache ?? .robotWithScissors
    }
}

struct ThumbnailView: View {
    let collage: Collage
    @State var cache = ThumbnailCache()
    @State var image: UIImage?

    var body: some View {
        Image(uiImage: (image ?? .robotWithScissors))
            .resizable()
            .scaledToFill()
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: { newWidth in
                cache.size = newWidth
            }
            .task {
                if image == nil, !Task.isCancelled {
                    image = await cache.thumbnail(from: collage)
                }
            }
    }
}
