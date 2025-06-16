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
    let subjectImage = {
        let height = 10.0
        let width = 10.0

        let imageBounds = CGRect(
            origin: .zero,
            size: CGSize(width: width * 2, height: height * 2)
        )

        var image = CIImage(color: .clear).cropped(to: imageBounds)

        let spotBounds = CGRect(
            origin: .zero,
            size: CGSize(width: width, height: height)
        ).offsetBy(dx: width / 2, dy: height / 2)

        let spot = CIImage(color: .blue).cropped(to: spotBounds)

        return UIImage(ciImage: spot.composited(over: image))
    }()

    //creates a 500x500 red and blue cross
    let cross = {
        let width = 500.0
        let height = 500.0

        let bounds = CGRect(
            origin: .zero,
            size: CGSize(width: width, height: height)
        )
        var image = CIImage(color: .clear).cropped(to: bounds)

        let white = CIImage(color: .white).cropped(
            to: CGRect(
                origin: CGPoint(x: 0, y: height / 2 - 5),
                size: CGSize(width: width, height: 10)
            )
        )
        image = white.composited(over: image)

        let spotBounds = CGRect(
            origin: CGPoint(x: width / 2 - 5, y: 0),
            size: CGSize(width: 10, height: height / 2)
        )
        let blue = CIImage(color: .blue).cropped(to: spotBounds)
        image = blue.composited(over: image)
        let red = CIImage(color: .red).cropped(
            to: spotBounds.offsetBy(dx: 0, dy: height / 2)
        )
        return UIImage(ciImage: red.composited(over: image))
    }()

    //creates a 400x400 checkerboard background
    let background = {
        var checkerBoardGenerator = CIFilter.checkerboardGenerator()
        checkerBoardGenerator.setDefaults()
        checkerBoardGenerator.center = CGPoint(x: 0, y: 0)
        checkerBoardGenerator.color0 = .gray
        checkerBoardGenerator.color1 = .black
        checkerBoardGenerator.width = 50
        checkerBoardGenerator.sharpness = 1
        let ciImage = checkerBoardGenerator.outputImage!.cropped(
            to: CGRect(x: 0.0, y: 0.0, width: 400, height: 400)
        )
        return UIImage(ciImage: ciImage)
    }()

    //creates a full Collage object,
    //can be used with any combination of mod or subject
    func makeCollage(mod: Modification? = nil, subject: UIImage? = nil)
        -> Collage
    {
        let sut = CollageFactory(
            mod: mod
                ?? Modification(translateX: 0.5, translateY: 0.5, scale: 0.5),
            subjectImage: subject ?? subjectImage,
            background: background,
            label: "testLabel",
            fileName: "testFileName"
        )
        return sut.create()
    }

    //TESTS//
    
    //TEST ALL TRIMMING//

    func testTrimming() {
        let result = Scanner().findSubjectSize(image: subjectImage)
        let expected = CGRect(x: 5, y: 5, width: 12, height: 12)
        XCTAssertEqual(result, expected)
    }

    //TEST ALL TRANSLATION//

    func testTranslate() {

        //centered
        let collage1 = makeCollage(
            mod: Modification(translateX: 0.5, translateY: 0.5, scale: 0.25)
        )

        assertSnapshot(of: collage1.image, as: .image, record: record)

        //top right
        let collage2 = makeCollage(
            mod: Modification(translateX: 1.0, translateY: 1.0, scale: 0.25)
        )

        assertSnapshot(of: collage2.image, as: .image, record: record)

        //top left
        let collage3 = makeCollage(
            mod: Modification(translateX: 0.0, translateY: 1.0, scale: 0.25)
        )

        assertSnapshot(of: collage3.image, as: .image, record: record)

        //bottom right
        let collage4 = makeCollage(
            mod: Modification(translateX: 1.0, translateY: 0.0, scale: 0.25)
        )

        assertSnapshot(of: collage4.image, as: .image, record: record)

        //bottom left
        let collage5 = makeCollage(
            mod: Modification(translateX: 0.0, translateY: 0.0, scale: 0.25)
        )

        assertSnapshot(of: collage5.image, as: .image, record: record)

        //top right, partially off
        let collage6 = makeCollage(
            mod: Modification(translateX: 1.1, translateY: 1.1, scale: 0.25)
        )

        assertSnapshot(of: collage6.image, as: .image, record: record)
    }

    //TEST ALL ROTATION//

    //test all logically significant rotation cases
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
    
    //TEST ALL SCALING//
    
    //test that subject scales to background given default mod values
    func testScaleToBackground() {
        let collage = makeCollage(subject: subjectImage)
        
        XCTAssertEqual(
            collage.json.annotation[0].coordinates,
            .init(x: 200, y: 200, width: 200, height: 200.0))
        assertSnapshot(of: collage.image, as: .image, record: record)
    }
    
    //test that subject scales to background given minimum scale values
    func testScaleMin() {
        let collage = makeCollage(
            mod: Modification(scale: Modification.scaleMin))

        assertSnapshot(of: collage.image, as: .image, record: record)
    }

    //test that subject scales to background given maximum scale values
    func testScaleMax() {
        let collage = makeCollage(
            mod: Modification(scale: Modification.scaleMax))

        assertSnapshot(of: collage.image, as: .image, record: record)
    }
    
    //TEST FLIPING//
    
    //test fliping on both axes
    func testFlip() {
        let collage = makeCollage(mod: Modification(flipX: true, flipY: true))

        assertSnapshot(of: collage.image, as: .image, record: record)
    }

    //TEST ALL ASSET GENERATION//
    
    //generation of preview image
    func testPreviewImage() {
        let collage = makeCollage()

        assertSnapshot(of: collage.previewImage, as: .image, record: record)
    }
    
    //generation of Collage Blueprint
    func testCollageBlueprint() {
        let collage = makeCollage()

        XCTAssertEqual(
            collage.json.annotation[0].coordinates,
                .init(x: 200, y: 200, width: 200, height: 200))
        assertSnapshot(of: collage.image, as: .image, record: record)
    }

    
    //COMBINATION TESTS//
    func testRotateAndTrim() {
        let blueprint = CollageFactory(
            mod: Modification(
                translateX: 0.5,
                translateY: 0.5,
                scale: 0.5,
                rotate: 0.125
            ),
            subjectImage: cross,
            background: background,
            label: "apple",
            fileName: "apple_.png"
        )
        let collage = blueprint.create()
        assertSnapshot(of: collage.previewImage, as: .image, record: record)
    }

    func testFlipAndTrim() {
        let width = 100.0
        let height = 100.0

        let bounds = CGRect(
            origin: .zero,
            size: CGSize(width: width, height: height)
        )
        var image = CIImage(color: .white).cropped(to: bounds)

        let spotBounds = CGRect(
            origin: .zero,
            size: CGSize(width: width / 2, height: height / 2)
        )
        let blue = CIImage(color: .blue).cropped(to: spotBounds)
        image = blue.composited(over: image)

        let red = CIImage(color: .red).cropped(
            to: spotBounds.offsetBy(dx: 0, dy: height / 2)
        )
        image = red.composited(over: image)

        let blueprint = CollageFactory(
            mod: Modification(
                translateX: 0.5,
                translateY: 0.5,
                scale: 0.5,
                flipX: true,
                flipY: true
            ),
            subjectImage: UIImage(ciImage: image.cropped(to: bounds)),
            background: .background,
            label: "apple",
            fileName: "apple_.png"
        )
        let collage = blueprint.create()

        assertSnapshot(of: collage.previewImage, as: .image, record: record)
    }

    func testRotateAndTranslate() {
        let image = makeCollage(
            mod: Modification(
                translateX: 0.5,
                translateY: 0.5,
                scale: 0.25,
                rotate: 0
            )
        ).image
        let image1 = makeCollage(
            mod: Modification(
                translateX: 0.5,
                translateY: 0.5,
                scale: 0.25,
                rotate: 1
            )
        ).image
        let image2 = makeCollage(
            mod: Modification(
                translateX: 0.5,
                translateY: 0.5,
                scale: 0.25,
                rotate: 0.5
            )
        ).image
        let image3 = makeCollage(
            mod: Modification(
                translateX: 0.5,
                translateY: 0.5,
                scale: 0.25,
                rotate: 0.25
            )
        ).image
        let image4 = makeCollage(
            mod: Modification(
                translateX: 0.5,
                translateY: 0.5,
                scale: 0.25,
                rotate: 0.75
            )
        ).image

        let image5 = makeCollage(
            mod: Modification(
                translateX: 0.83,
                translateY: 0.83,
                scale: 0.25,
                rotate: 0
            )
        ).image
        let image6 = makeCollage(
            mod: Modification(
                translateX: 0.83,
                translateY: 0.83,
                scale: 0.25,
                rotate: 0.25
            )
        ).image
        let image7 = makeCollage(
            mod: Modification(
                translateX: 0.83,
                translateY: 0.83,
                scale: 0.25,
                rotate: 0.5
            )
        ).image
        let image8 = makeCollage(
            mod: Modification(
                translateX: 0.83,
                translateY: 0.83,
                scale: 0.25,
                rotate: 0.75
            )
        ).image

        let images = [
            image, image1, image2, image3, image4, image5, image6, image7,
            image8,
        ]

        for image in images {
            assertSnapshot(of: image, as: .image, record: record)
        }
    }

}
