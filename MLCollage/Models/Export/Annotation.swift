//
//  Annotation.swift
//  MLCollage
//
//  Created by Robert Bates on 11/9/24.
//

import Foundation

struct Annotation: Codable, Equatable {
    var label: String = ""
    var coordinates = Coordinates()

    init(label: String, coordinates: Coordinates = Coordinates()) {
        self.label = label
        self.coordinates = coordinates
    }
    
    struct Coordinates: Codable, Equatable {
        var x: Double = 0
        var y: Double = 0
        var width: Double = 0
        var height: Double = 0
    }
}

extension Annotation.Coordinates {
    init(_ extent: CGRect, backgroundHeight: CGFloat) {
        x = extent.midX
        y = backgroundHeight - extent.midY
        width = extent.width
        height = extent.height
    }
}
