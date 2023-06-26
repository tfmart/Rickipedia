//
//  QueryResponse.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

struct QueryResponse: Decodable {
    let info: QueryInfo
    let results: [Character]
}
