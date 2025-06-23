//
//  BackgroundModel.swift
//  MLCollage
//
//  Created by Robert Bates on 4/28/25.
//

import Foundation
import SwiftData
import UIKit

@Model
final class BackgroundModel: Identifiable {
    var id: String
    var image: Data
    
    init(image: MLCImage) {
        self.id = image.id
        self.image = image.uiImage.pngData()!
    }
    
    func toMLCImage() -> MLCImage {
        MLCImage(id: id, uiImage: UIImage(data: image)!)
    }
}

extension BackgroundModel {
    static let mock: BackgroundModel = {
        BackgroundModel(image: MLCImage(uiImage: .draftingBackground))
    }()
    
    static let mock1: BackgroundModel = {
        BackgroundModel(image: MLCImage(uiImage: .corkBackground))
    }()
    
    static let mock2: BackgroundModel = {
        BackgroundModel(image: MLCImage(uiImage: .notebookPaper))
    }()
}
