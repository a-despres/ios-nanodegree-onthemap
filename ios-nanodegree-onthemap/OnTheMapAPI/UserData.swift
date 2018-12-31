//
//  UserData.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/30/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let firstName: String
    let imageURL: String
    let key: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case imageURL = "_image_url"
        case key
        case lastName = "last_name"
        case nickname
    }
}
