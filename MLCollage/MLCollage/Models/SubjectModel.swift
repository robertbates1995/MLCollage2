//
//  Item.swift
//  MLCollage
//
//  Created by Robert Bates on 4/28/25.
//

import Foundation
import SwiftData
import UIKit

@Model
final class SubjectModel: Identifiable {
    var label: String
    @Relationship(deleteRule: .cascade, inverse: \SubjectImageModel.subject)
    var images: [SubjectImageModel]
    
    init(label: String, images: [SubjectImageModel] = [SubjectImageModel]()) {
        self.label = label
        self.images = images
    }
}

@Model
final class SubjectImageModel: Identifiable {
    var subject: SubjectModel?
    var image: Data

    init(image: Data) {
        self.image = image
    }
    
    func toImage() -> UIImage {
        UIImage(data: image)!
    }
}

extension SubjectImageModel {
    convenience init (image: UIImage, subject: SubjectModel) {
        self.init(image: image.pngData()!)
        self.subject = subject
    }
}
