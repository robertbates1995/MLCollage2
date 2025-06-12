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

        var leftHit = false
        var left = 0
        var right = 0
        var top = 0
        var bottom = totalHeight

        //----------------------------------------------//
        //NEW ALGORITHIM
        //use array compare for finding non-clear pixel

        //creating a row of alpha data
        func checkRowFilled(at height: Int) -> Bool {
            for i in 0..<totalWidth {
                let pixelIndex =
                    (totalHeight - height - 1) * cgImage.bytesPerRow + i * 4
                if data[pixelIndex + 3] != 0 {
                    return true
                }
            }
            return false
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
        
        

        //creating a column of alpha data

        //scan the top down till the first pixel
        for height in 0..<totalHeight {
            //create row of pixels at current height
            if checkRowFilled(at: height) {
                bottom = height
            }
            //compare row at current height against empty row
            //if row at height is not same, height is bottom value
        }

        //repeat for bottom
        for height in (0..<totalHeight).reversed() {
            //create row of pixels at current height
            //compare row at current height against empty row
            //if row at height is not same, height is top value
            if checkRowFilled(at: height) {
                top = height
            }
        }

        //crop image to new top and bottom values?
        //alternatively, how can i create columns of only the relevent pixels(cut off top and bottom)?
        
        //find range of columns
        let range = bottom..<top

        //scan in from left and right but ommit the margins cut off by the top and bottom
        for width in range {
            //create column of pixels at current height
            //compare column at current width against empty column
            //if column at height is not same, width is left value
            left = width
        }

        for width in range.reversed() {
            //create column of pixels at current height
            //compare column at current width against empty column
            //if column at height is not same, width is right value
            right = width
        }

        //----------------------------------------------//

        let size = CGSize(
            width: (right - left),
            height: (top - bottom)
        )

        return CGRect(origin: CGPoint(x: left, y: bottom), size: size)
    }
}

func findSubjectSize1(image: UIImage) -> CGRect {
    guard let cgImage = image.toCGImage().cgImage,
        cgImage.colorSpace?.model == .rgb,
        cgImage.bitsPerPixel == 32,
        cgImage.bitsPerComponent == 8,
        let pixelData = cgImage.dataProvider?.data
    else { return CGRect(origin: CGPoint(x: 0, y: 0), size: image.size) }
    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

    let totalWidth = cgImage.width
    let totalHeight = cgImage.height

    var leftHit = false
    var left = 0
    var right = 0
    var top = 0
    var bottom = totalHeight

    //----------------------------------------------//
    //NEW ALGORITHIM
    //use array compare for finding non-clear pixel

    //creating a row of alpha data
    func checkRowFilled(at height: Int) -> Bool {
        for i in 0..<totalWidth {
            let pixelIndex =
                (totalHeight - height - 1) * cgImage.bytesPerRow + i * 4
            if data[pixelIndex + 3] != 0 {
                return true
            }
        }
        return false
    }

    //creating a column of alpha data

    //scan the top down till the first pixel
    for height in 0..<totalHeight {
        //create row of pixels at current height
        while checkRowFilled(at: height) {
            bottom = height
        }
        //compare row at current height against empty row
        //if row at height is not same, height is bottom value
    }

    //repeat for bottom
    for height in (0..<totalHeight).reversed() {
        //create row of pixels at current height
        //compare row at current height against empty row
        //if row at height is not same, height is top value
        top = height
    }

    //crop image to new top and bottom values?
    //alternatively, how can i create columns of only the relevent pixels(cut off top and bottom)?

    //scan in from left and right but ommit the margins cut off by the top and bottom
    for width in 0..<totalWidth {
        //create column of pixels at current height
        //compare column at current width against empty column
        //if column at height is not same, width is left value
        left = width
    }

    for width in (0..<totalWidth).reversed() {
        //create column of pixels at current height
        //compare column at current width against empty column
        //if column at height is not same, width is right value
        right = width
    }

    //----------------------------------------------//

    let size = CGSize(
        width: (right - left),
        height: (top - bottom)
    )

    return CGRect(origin: CGPoint(x: left, y: bottom), size: size)
}
