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
        var right = 0
        var top = totalHeight
        var bottom = 0

        //creating a row of alpha data
        func checkRowEmpty(at height: Int) -> Bool {
            for i in 0..<totalWidth {
                let pixelIndex =
                    (totalHeight - height) * cgImage.bytesPerRow + i * 4
                if data[pixelIndex + 3] != 0 {
                    return false
                }
            }
            return true
        }
        
        //creating a column of alpha data
        func checkColumnFilled(at width: Int, range: Range<Int>) -> Bool {
            for i in range {
                let pixelIndex =
                    (totalHeight - i - 1) * cgImage.bytesPerRow + width * 4
                if data[pixelIndex + 3] != 0 {
                    return true
                }
            }
            return false
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
                bottom = height
            } else {
                break
            }
        }
        
        //find range of columns
        let range = bottom...top

        //scan in from left and right but ommit the margins cut off by the top and bottom
        for width in range.reversed() {
            //create column of pixels at current height
            //compare column at current width against empty column
            //if column at height is not same, width is left value
            left = width
        }
        
        for width in range {
            //create column of pixels at current height
            //compare column at current width against empty column
            //if column at height is not same, width is right value
            right = width
        }

        let size = CGSize(
            width: (right - left - 1),
            height: (top - bottom - 1)
        )

        return CGRect(origin: CGPoint(x: left, y: bottom), size: size)
    }
}
