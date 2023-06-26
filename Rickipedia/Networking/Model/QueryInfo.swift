//
//  QueryInfo.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

struct QueryInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
