//
//  RKPCharacterGender.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public enum RKPCharacterGender: String, Decodable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}
