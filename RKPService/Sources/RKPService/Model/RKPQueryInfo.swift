//
//  RKPQueryInfo.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public struct RKPQueryInfo: Decodable {
    public let count: Int
    public let pages: Int
    public let next: String?
    public let prev: String?
}
