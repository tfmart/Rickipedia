//
//  RKPRetryFooterTests.swift
//  
//
//  Created by Tomas Martins on 01/07/23.
//

import XCTest
import SnapshotTesting
@testable import RKPDesign

final class RKPRetryFooterTests: XCTestCase {
    func testRetryFooter() {
        let retryFooter = RKPRetryFooter(frame: CGRect(x: 0, y: 0, width: 320, height: 80))
        retryFooter.configure(message: "Failed to load data", action: {
            // Retry button tapped action
        })
        
        let viewController = SnapshotViewController(contentView: retryFooter)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: .init(userInterfaceStyle: .light)))
    }
}

