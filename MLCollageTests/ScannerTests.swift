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
    
    //TESTS//
    
        //Check to ensure test image is what is expected.
        //Fails for some unknown reason, but the
        //image seems to be correct.
    func testImage() {
        assertSnapshot(of: image, as: .image, record: record)
    }
    
    
    //TEST ALL TRIMMING//
    
    func testTrimming() {
        let result = Scanner().findSubjectSize(image: image)
        testTopTrim(result)
        testBottomTrim(result)
        testLeftTrim(result)
        testRightTrim(result)
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
    func testLeftTrim(_ sut: CGRect) {
        XCTAssertEqual(sut.minX, 5)
    }
    
        //test right trim value
    func testRightTrim(_ sut: CGRect) {
        XCTAssertEqual(sut.maxX, 16)
    }
    
    
    //TEST ALL ROTATION//
    
    func testRotate() {
        let collage = makeCollage(
            mod: Modification(rotate: 0)
        ).image
        let collage1 = makeCollage(
            mod: Modification(rotate: 1)
        ).image
        let collage2 = makeCollage(
            mod: Modification(rotate: 0)
        ).image
        let collage3 = makeCollage(
            mod: Modification(rotate: 0.25)
        ).image
        let collage4 = makeCollage(
            mod: Modification(rotate: 0.75)
        ).image

        let collages = [collage, collage1, collage2, collage3, collage4]

        for collage in collages {
            assertSnapshot(of: collage, as: .image, record: record)
        }
        XCTAssertEqual(collage.pngData(), collage.pngData())
        XCTAssertEqual(collage.pngData(), collage1.pngData())
        XCTAssertEqual(collage.pngData(), collage2.pngData())
    }
    
    //TEST IMAGE GENERATION
    func testPreviewImage() {
        let collage = makeCollage()

        assertSnapshot(of: collage.previewImage, as: .image, record: record)
    }
    
    
    //combination tests that still need to be sorted//
    func testRotateAndTrim() {
        let blueprint = CollageFactory(
            mod: Modification(
                translateX: 0.5,
                translateY: 0.5,
                scale: 0.5,
                rotate: 0.125),
            subjectImage: cross,
            background: background,
            label: "apple",
            fileName: "apple_.png")
        let collage = blueprint.create()
        assertSnapshot(of: collage.previewImage, as: .image, record: record)
    }
    
        
    
   
    
}
