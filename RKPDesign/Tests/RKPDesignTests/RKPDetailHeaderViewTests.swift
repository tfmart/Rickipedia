//
//  RKPDetailHeaderViewTests.swift
//  
//
//  Created by Tomas Martins on 01/07/23.
//

import Foundation

import XCTest
import SnapshotTesting
@testable import RKPDesign

final class RKPDetailHeaderViewTests: XCTestCase {
    func testDetailCell() {
        let mock = RKPDetailHeaderView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        guard let pathString = Bundle.module.path(forResource: "avatar", ofType: "png") else {
            XCTFail("Could not find avatar image")
            return
        }
        
        mock.configure(with: "Rick & Morty", imageURL: URL(string: pathString))
        
        let viewController = SnapshotViewController(contentView: mock)
        let lightMode = UITraitCollection(userInterfaceStyle: .light)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: lightMode))
        let darkMode = UITraitCollection(userInterfaceStyle: .dark)
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: darkMode))
    }
}
