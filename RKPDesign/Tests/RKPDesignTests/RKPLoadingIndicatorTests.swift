//
//  RKPLoadingIndicatorTests.swift
//  
//
//  Created by Tomas Martins on 01/07/23.
//

import XCTest
import SnapshotTesting
@testable import RKPDesign

final class RKPLoadingIndicatorTests: XCTestCase {
    func testLoadingIndicator() {
        let loadingIndicator = RKPLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        let viewController = SnapshotViewController(contentView: loadingIndicator)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: .init(userInterfaceStyle: .light)))
    }
}
