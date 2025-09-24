//
//  UIImage+CIImage.swift
//  MLCollage
//
//  Created by Robert Bates on 10/4/24.
//

import UIKit

extension UIImage {
    func toCGImage() -> UIImage {
        guard let ciImage = self.ciImage else {
            return self
        }
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return self
    }

    func toCIImage() -> CIImage {
        if let temp = self.ciImage { return temp }
        return CIImage(
            image: self,
            options: [
                .applyOrientationProperty: true,
                .properties: [
                    kCGImagePropertyOrientation: CGImagePropertyOrientation(
                        imageOrientation
                    ).rawValue
                ],
            ])!
    }
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            self = .up
        }
    }
}
