//
//  RKPQueryResponse.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public struct RKPQueryResponse: Decodable {
    public let info: RKPQueryInfo
    public let results: [RKPCharacter]
}
