//
//  CharacterErrorHandler.swift
//  Rickipedia
//
//  Created by Tomas Martins on 01/07/23.
//

import Foundation
import RKPService

protocol CharacterErrorHandler {
    func message(for error: Error) -> String
    func shouldShowRetry(for error: Error) -> Bool
}

class DefaultCharacterErrorHandler: CharacterErrorHandler {
    func message(for error: Error) -> String {
        let unknownErrorMessage = "An unknown error occurred. Please try again later"
        if let error = (error as? RKPNetworkingError) {
            switch error {
            case .serviceError(let message):
                return message
            case .badURL:
                return unknownErrorMessage
            }
        } else {
            return unknownErrorMessage
        }
    }

    func shouldShowRetry(for error: Error) -> Bool {
        guard let networkError = (error as? RKPNetworkingError) else {
            return true
        }
        switch networkError {
        case .badURL:
            return true
        case .serviceError(let message):
            return message.lowercased() != "there is nothing here"
        }
    }
}
