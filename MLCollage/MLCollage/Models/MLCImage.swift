//
//  MLCImage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/2/24.
//

import UIKit
import Foundation
import SwiftData
import SwiftUI

final class MLCImage: Identifiable {
    var id: String = UUID().uuidString
    var uiImage: UIImage
    
    init(id: String, uiImage: UIImage) {
        self.id = id
        self.uiImage = uiImage
    }
}

extension MLCImage {
    convenience init(uiImage: UIImage) {
        self.init(id: UUID().uuidString, uiImage: uiImage)
    }
}
