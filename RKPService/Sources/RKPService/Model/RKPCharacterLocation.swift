//
//  RKPCharacterLocation.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public struct RKPCharacterLocation: Decodable {
    public var name: String
    public var url: String
}

extension RKPCharacterLocation: Hashable {
    
}
