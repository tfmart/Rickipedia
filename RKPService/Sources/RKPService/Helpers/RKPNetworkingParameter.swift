//
//  RKPNetworkingParameter.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

enum RKPNetworkingParameter: String {
    case name
    case status
    case page
}

extension URLQueryItem {
    init(parameter: RKPNetworkingParameter, value: String?) {
        self.init(name: parameter.rawValue, value: value)
    }
    
    init<N: Numeric & CustomStringConvertible>(parameter: RKPNetworkingParameter, numericValue: N?) {
            if let numericValue {
                self.init(name: parameter.rawValue, value: "\(numericValue)")
            } else {
                self.init(name: parameter.rawValue, value: nil)
            }
        }
}
