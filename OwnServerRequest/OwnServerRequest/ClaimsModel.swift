//
//  ClaimsModel.swift
//  OwnServerRequest
//
//  Created by Tommy Ludwig on 04.04.23.
//

import Foundation
import SwiftJWT

struct MyClaims: Claims {
    let iss: String
    let sub: String
    let exp: Date
    let appId: String
    let admin: Bool
}

