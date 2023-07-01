//
//  MockCharacterErrorHandler.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 01/07/23.
//

import Foundation
@testable import Rickipedia

class MockCharacterErrorHandler: CharacterErrorHandler {
    func message(for error: Error) -> String {
        return "Error message"
    }

    func shouldShowRetry(for error: Error) -> Bool {
        return true
    }
}
