//
//  Scanner.swift
//  MLCollage
//
//  Created by Robert Bates on 1/31/25.
//

import UIKit

struct Scanner {

    func findSubjectSize(image: UIImage) -> CGRect {
        guard let cgImage = image.toCGImage().cgImage,
            cgImage.colorSpace?.model == .rgb,
            cgImage.bitsPerPixel == 32,
            cgImage.bitsPerComponent == 8,
            let pixelData = cgImage.dataProvider?.data
        else { return CGRect(origin: CGPoint(x: 0, y: 0), size: image.size) }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)


        let width = cgImage.width
        let height = cgImage.height

        var leftHit = false
        var left = 0
        var right = 0
        var top = 0
        var bottom = height

        for x in 0..<width {
            for y in 0..<height {
                //this scan will go from left to right, bottom to top.
                
                let pixelIndex = (height - y - 1) * cgImage.bytesPerRow + x * 4

                let alpha = data[pixelIndex + 3]
                
                if alpha != 0 {
                    //left value is first point seen
                    if !leftHit {
                        left = x
                        leftHit = true
                    }
                    //bottom value is lowest seen height value
                    if bottom > y {
                        bottom = y
                    }
                    //top value is highest seen height value
                    if top <= y {
                        top = y + 1
                    }
                    //right value is last point seen
                    if right <= x {
                        right = x + 1
                    }
                }
            }
        }

        let size = CGSize(
            width: (right - left),
            height: (top - bottom))

        return CGRect(origin: CGPoint(x: left, y: bottom), size: size)
    }
}
