//
//  RKPCharacterStatus.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public enum RKPCharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
