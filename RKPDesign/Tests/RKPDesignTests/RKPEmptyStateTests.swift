//
//  RKPEmptyStateTests.swift.swift
//  
//
//  Created by Tomas Martins on 01/07/23.
//

import XCTest
import SnapshotTesting
@testable import RKPDesign

final class RKPEmptyStateTests: XCTestCase {
    func testEmptyState() {
        let emptyState = RKPEmptyState(message: "No data available", showRetry: false)
        
        let viewController = SnapshotViewController(contentView: emptyState)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: .init(userInterfaceStyle: .light)))
    }
    
    func testEmptyStateWithRetry() {
        let emptyState = RKPEmptyState(message: "No internet connection", showRetry: true)
        emptyState.addRetryButton {
            // Retry button tapped action
        }
        
        let viewController = SnapshotViewController(contentView: emptyState)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: .init(userInterfaceStyle: .light)))
    }
}
