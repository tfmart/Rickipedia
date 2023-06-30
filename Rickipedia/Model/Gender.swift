//
//  Gender.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

enum Gender: String, Decodable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}
