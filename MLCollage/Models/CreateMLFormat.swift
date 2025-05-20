//
//  SubjectData.swift
//  MLCollage
//
//  Created by Robert Bates on 7/26/24.
//

import Foundation

struct CreateMLFormat: Codable, Equatable {
    var annotation: [Annotation]
    var imagefilename: String
    
    init(annotation: [Annotation], imagefilename: String) {
        self.annotation = annotation
        self.imagefilename = imagefilename
    }
}
