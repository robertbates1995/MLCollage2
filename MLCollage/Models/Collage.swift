//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import CoreImage
import Foundation
import UIKit

class Collage: Identifiable {
    let id = UUID()
    var image: UIImage
    var previewImage: UIImage
    var json: CreateMLFormat

    init(image: UIImage, previewImage: UIImage, json: CreateMLFormat) {
        self.image = image
        self.previewImage = previewImage
        self.json = json
    }
}

extension Array where Element == Collage {
    var json: Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init(arrayLiteral: [
            .prettyPrinted, .sortedKeys,
        ])
        let output = try! encoder.encode(self.map(\.json))
        return output
    }
}

