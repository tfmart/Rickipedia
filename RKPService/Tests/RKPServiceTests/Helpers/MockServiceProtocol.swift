//
//  File.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation
@testable import RKPService

protocol MockServiceProtocol {

}

extension MockServiceProtocol {
    func failRequest() throws -> RKPNetworkingError {
        guard let pathString = Bundle.module.path(forResource: "requestError", ofType: "json") else {
            fatalError("Could not find mock JSON file")
        }
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert mock JSON file to Data")
        }
        let errorMessage = try JSONDecoder().decode(RKPErrorMessage.self, from: jsonData)
        return .serviceError(errorMessage.error)
    }
}
