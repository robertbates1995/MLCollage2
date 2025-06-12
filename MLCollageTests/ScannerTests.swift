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
    
    let sut = {
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
    
    func testImage() {
        assertSnapshot(of: sut, as: .image, record: record)
    }
    
    func testTopTrim() {
        
    }
    
    func testBottomTrim() {
        
    }
    
    func testLeftTrim() {
        
    }
    
    func testRightTrim() {
        
    }
    
}
