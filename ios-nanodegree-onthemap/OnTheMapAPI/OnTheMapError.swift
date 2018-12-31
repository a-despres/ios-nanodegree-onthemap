//
//  OnTheMapError.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/30/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import Foundation

struct OnTheMapError: Codable, Error {
    let status: Int
    let parameter: String?
    let error: String
}
