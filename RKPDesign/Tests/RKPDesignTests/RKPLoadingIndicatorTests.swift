//
//  RKPLoadingIndicatorTests.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import XCTest
import SnapshotTesting
@testable import RKPDesign

final class RKPLoadingIndicatorTests: XCTestCase {
    func testLoadingIndicator() {
        let mock = RKPLoadingIndicator()
        mock.translatesAutoresizingMaskIntoConstraints = false
        mock.heightAnchor.constraint(equalToConstant: 100).isActive = true
        mock.widthAnchor.constraint(equalToConstant: 100).isActive = true
        assertSnapshot(matching: mock, as: .image)
    }
}
