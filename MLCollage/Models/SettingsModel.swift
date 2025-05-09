//
//  ProjectSettings.swift
//  MLCollage
//
//  Created by Robert Bates on 9/5/24.
//

import Foundation
import SwiftData

@Model
final class SettingsModel {
    var numberOfEachSubject: Double
    var translate: Bool
    var scale: Bool
    var rotate: Bool
    var mirror: Bool
    var outputSize: Outputsize
    var numberOfEachSubjectRange: ClosedRange<Double> {
        10.0...1000
    }

    init(
        numberOfEachSubject: Double = 30.0,
        translate: Bool = true,
        scale: Bool = true,
        rotate: Bool = true,
        mirror: Bool = true,
        outputSize: Outputsize = Outputsize.s299
    ) {
        self.numberOfEachSubject = numberOfEachSubject
        self.translate = translate
        self.scale = scale
        self.rotate = rotate
        self.mirror = mirror
        self.outputSize = outputSize
    }
}

enum Outputsize: String, CaseIterable, Codable {
    case s299 = "299"
    case s512 = "512"
    case s1024 = "1024"
    
    var asFloat: CGFloat {
        switch self {
            case .s299: return 299
            case .s512: return 512
            case .s1024: return 1024
        }
    }
}
