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
    
    static let mock1: SubjectModel = {
        let imageModel = SubjectImage(
            image: UIImage(resource: .ball1).pngData()!
        )
        
        let imageModel2 = SubjectImage(
            image: UIImage(resource: .ball2).pngData()!
            
        )
        
        let imageModel3 = SubjectImage(
            image: UIImage(resource: .ball3).pngData()!
        )
        
        let imageModel4 = SubjectImage(
            image: UIImage(resource: .ball4).pngData()!
            
        )
        
        let imageModel5 = SubjectImage(
            image: UIImage(resource: .ball5).pngData()!
        )
        
        let imageModel6 = SubjectImage(
            image: UIImage(resource: .ball6).pngData()!
            
        )
        
        return SubjectModel(label: "mock subject", images: [imageModel, imageModel2, imageModel3, imageModel4, imageModel5, imageModel6])
    }()
    
    static let mock2: SubjectModel = {
        let imageModel = SubjectImage(
            image: UIImage(resource: .boot1).pngData()!
        )
        
        let imageModel2 = SubjectImage(
            image: UIImage(resource: .boot2).pngData()!
            
        )
        
        let imageModel3 = SubjectImage(
            image: UIImage(resource: .boot3).pngData()!
        )
        
        let imageModel4 = SubjectImage(
            image: UIImage(resource: .boot4).pngData()!
            
        )
        
        let imageModel5 = SubjectImage(
            image: UIImage(resource: .boot5).pngData()!
        )
        
        let imageModel6 = SubjectImage(
            image: UIImage(resource: .boot6).pngData()!
            
        )
        
        return SubjectModel(label: "mock subject", images: [imageModel, imageModel2, imageModel3, imageModel4, imageModel5, imageModel6])
    }()
    
    static let mock3: SubjectModel = {
        let imageModel = SubjectImage(
            image: UIImage(resource: .pot1).pngData()!
        )
        
        let imageModel2 = SubjectImage(
            image: UIImage(resource: .pot2).pngData()!
            
        )
        
        let imageModel3 = SubjectImage(
            image: UIImage(resource: .pot3).pngData()!
        )
        
        let imageModel4 = SubjectImage(
            image: UIImage(resource: .pot4).pngData()!
            
        )
        
        let imageModel5 = SubjectImage(
            image: UIImage(resource: .pot5).pngData()!
        )
        
        let imageModel6 = SubjectImage(
            image: UIImage(resource: .pot6).pngData()!
            
        )
        
        return SubjectModel(label: "mock subject", images: [imageModel, imageModel2, imageModel3, imageModel4, imageModel5, imageModel6])
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
