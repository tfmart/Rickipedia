//
//  RKPCharacterDetailCellTests.swift
//  
//
//  Created by Tomas Martins on 01/07/23.
//

import XCTest
import SnapshotTesting
@testable import RKPDesign

final class RKPCharacterDetailCellTests: XCTestCase {
    func testDetailCell() {
        let mock = RKPCharacterDetailCell(frame: CGRect(x: 0, y: 0, width: 320, height: 80))
        mock.configure(title: "Location", value: "Earth")
        
        let viewController = SnapshotViewController(contentView: mock)
        let lightMode = UITraitCollection(userInterfaceStyle: .light)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: lightMode))
        let darkMode = UITraitCollection(userInterfaceStyle: .dark)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: darkMode))
    }
}
