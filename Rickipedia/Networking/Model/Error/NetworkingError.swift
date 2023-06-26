//
//  NetworkingError.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

enum NetworkingError: Error {
    case badURL
    case serviceError(_: String)
}
