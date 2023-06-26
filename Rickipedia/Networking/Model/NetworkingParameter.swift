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
    case page
}

extension URLQueryItem {
    init(parameter: NetworkingParameter, value: String?) {
        self.init(name: parameter.rawValue, value: value)
    }
    
    init<N: Numeric & CustomStringConvertible>(parameter: NetworkingParameter, numericValue: N?) {
            if let numericValue {
                self.init(name: parameter.rawValue, value: "\(numericValue)")
            } else {
                self.init(name: parameter.rawValue, value: nil)
            }
        }
}
