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

extension QueryInfo {
    var nextPage: Int? {
        guard let next,
              let nextURL = URLComponents(string: next),
              let pageQuery =  nextURL.queryItems?.first(where: {
                  $0.name == "page"
              }),
              let pageValue = pageQuery.value else {
            return nil
        }
        return Int(pageValue)
    }
}
