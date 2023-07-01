//
//  RKPNetworkingError.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public enum RKPNetworkingError: Error {
    case badURL
    case serviceError(_: String)
}

extension RKPNetworkingError: Equatable {
    public static func == (lhs: RKPNetworkingError, rhs: RKPNetworkingError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL): return true
        case (.serviceError(let lhsError), .serviceError(let rhsError)): return lhsError == rhsError
        default: return false
        }
    }
}
