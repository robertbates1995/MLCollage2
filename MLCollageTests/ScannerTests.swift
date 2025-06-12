//
//  CollageTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 7/31/24.
//

import CoreImage.CIFilterBuiltins
import CustomDump
import Foundation
import SnapshotTesting
import SwiftUICore
import UIKit
import XCTest

@testable import MLCollage

@MainActor
final class ScannerTests: XCTestCase {
    let record = false
    
    //creates a blue 10x10 square centered on a clear 20x20 canvas
    let image = {
        let height = 10.0
        let width = 10.0
        
        let imageBounds = CGRect(
            origin: .zero, size: CGSize(width: width * 2, height: height * 2))
        
        var image = CIImage(color: .clear).cropped(to: imageBounds)
        
        let spotBounds = CGRect(
            origin: .zero, size: CGSize(width: width, height: height )).offsetBy(dx: width/2, dy: height/2)
        
        let spot = CIImage(color: .blue).cropped(to: spotBounds)
        
        return UIImage(ciImage: spot.composited(over: image))
    }()
    
    //Check to ensure test image is what is expected
    func testImage() {
        assertSnapshot(of: image, as: .image, record: record)
    }
    
    func testScanner() {
        let result = Scanner().findSubjectSize(image: image)
        testTopTrim(result)
        testBottomTrim(result)
    }
    
    //test top trim value
    func testTopTrim(_ sut: CGRect) {
        XCTAssertEqual(sut.maxY, 16)
    }
    
    //test bottom trim value
    func testBottomTrim(_ sut: CGRect) {
        XCTAssertEqual(sut.minY, 5)
    }
    
    //test left trim value
    func testLeftTrim() {
        
    }
    
    //test right trim value
    func testRightTrim() {
        
    }
    
}
