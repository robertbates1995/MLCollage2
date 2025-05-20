//
//  Modification.swift
//  MLCollage
//
//  Created by Robert Bates on 11/8/24.
//

import Foundation

struct Modification {
    var translateX: CGFloat = 0.0
    var translateY: CGFloat = 0.0
    static let translateMax: CGFloat = 1.0
    var scale: CGFloat = 1.0
    static let scaleMin: CGFloat = 0.10
    static let scaleMax: CGFloat = 1.5
    var rotate: CGFloat = 0.0
    static let rotateMax: CGFloat = 1.0
    var flipX: Bool = false
    var flipY: Bool = false
}
