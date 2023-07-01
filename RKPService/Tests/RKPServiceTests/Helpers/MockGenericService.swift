//
//  File.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation
@testable import RKPService

class MockGenericService: Service {
    var queries: [URLQueryItem]
    
    init(queries: [URLQueryItem]) {
        self.queries = queries
    }
}
