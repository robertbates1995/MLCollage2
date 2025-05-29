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
    @Relationship(deleteRule: .cascade, inverse: \SubjectImage.subject)
    var images: [SubjectImage]
    
    init(label: String, images: [SubjectImage] = [SubjectImage]()) {
        self.label = label
        self.images = images
    }
}

extension SubjectModel {
    static let mock: SubjectModel = {
        let imageModel = SubjectImage(
            image: UIImage(resource: .robotWithScissors).pngData()!
        )
        
        let imageModel2 = SubjectImage(
            image: UIImage(resource: .folderTab).pngData()!
            
        )
        
        let imageModel3 = SubjectImage(
            image: UIImage(resource: .photoStack).pngData()!
        )
        
        let imageModel4 = SubjectImage(
            image: UIImage(resource: .notebookPaper).pngData()!
        )
        
        return SubjectModel(label: "mock subject", images: [imageModel, imageModel2, imageModel3, imageModel4])
    }()
}

@Model
final class SubjectImage: Identifiable {
    var subject: SubjectModel?
    var image: Data

    init(image: Data) {
        self.image = image
    }
    
    func toImage() -> UIImage {
        UIImage(data: image)!
    }
}

extension SubjectImage {
    convenience init (image: UIImage, subject: SubjectModel) {
        self.init(image: image.pngData()!)
        self.subject = subject
    }
}
