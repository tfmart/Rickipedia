//
//  RKPCharacterCellTests.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import XCTest
import SnapshotTesting
@testable import RKPDesign

final class RKPCharacterCellTests: XCTestCase {
    func testCell() {
        let mock = RKPCharacterCell()
        guard let pathString = Bundle.module.path(forResource: "avatar", ofType: "png") else {
            XCTFail("Could not find avatar image")
            return
        }
        
        mock.configure(with: "Rick & Morty", imageURL: URL(string: pathString))
        mock.translatesAutoresizingMaskIntoConstraints = false
        mock.heightAnchor.constraint(equalToConstant: 100).isActive = true
        assertSnapshot(matching: mock, as: .image)
    }
}
