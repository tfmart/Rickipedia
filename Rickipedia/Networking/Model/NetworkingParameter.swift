//
//  NetworkingParameter.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

enum NetworkingParameter: String {
    case name
    case status
}

extension URLQueryItem {
    init(parameter: NetworkingParameter, value: String?) {
        self.init(name: parameter.rawValue, value: value)
    }
}
