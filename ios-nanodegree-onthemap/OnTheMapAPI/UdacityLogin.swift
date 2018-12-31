//
//  UdacityLogin.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/30/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import Foundation

struct UdacityLogin: Codable {
    let login: Login
    
    enum CodingKeys: String, CodingKey {
        case login = "udacity"
    }
}
