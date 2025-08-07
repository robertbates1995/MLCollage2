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

        let totalWidth = cgImage.width
        let totalHeight = cgImage.height

        var left = 0
        var right = totalWidth
        var top = totalHeight
        var bottom = 0

        //creating a row of alpha data
        func checkRowEmpty(at height: Int) -> Bool {
            for i in 0..<totalWidth {
                let pixelIndex =
                    (totalHeight - 1 - height) * cgImage.bytesPerRow + i * 4
                if data[pixelIndex + 3] != 0 {
                    return false
                }
            }
            return true
        }

        func checkColumnEmpty(at column: Int) -> Bool {
            for row in 0..<totalHeight {
                let pixelIndex = row * cgImage.bytesPerRow + column * 4
                if data[pixelIndex + 3] != 0 {
                    return false
                }
            }
            return true
        }

        //scan the top down till the first pixel
        for height in (0..<totalHeight).reversed() {
            //create row of pixels at current height
            if checkRowEmpty(at: height) {
                top = height
            } else {
                break
            }
            //compare row at current height against empty row
            //if row at height is not same, height is bottom value
        }

        //repeat for bottom
        for height in 0..<totalHeight {
            //create row of pixels at current height
            //compare row at current height against empty row
            //if row at height is not same, height is top value
            if checkRowEmpty(at: height) {
                bottom = height + 1
            } else {
                break
            }
        }

        //scan in from left and right but ommit the margins cut off by the top and bottom
        for column in 0..<totalWidth {
            //create column of pixels at current height
            left = column
            if !checkColumnEmpty(at: column) {
                break
            }
            //compare column at current width against empty column

            //if column at height is not same, width is left value
            
        }

        for column in (left..<totalWidth).reversed() {
            //create column of pixels at current height
            if !checkColumnEmpty(at: column) {
                break
            }
            right = column
            //compare column at current width against empty column
            //if column at height is not same, width is right value
        }

        let size = CGSize(
            width: (right - left),
            height: (top - bottom)
        )

        return CGRect(origin: CGPoint(x: left, y: bottom), size: size)
    }
}
