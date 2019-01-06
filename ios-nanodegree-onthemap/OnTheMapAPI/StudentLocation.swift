//
//  StudentLocation.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    
    struct Default {
        static let firstName: String = "Ignacius"
        static let lastName: String = "VonShnitzel"
        static let latitude: Double = 82.8628
        static let longitude: Double = 135
        static let mapString: String = "South Alaska"
        static let mediaURL: String = "https://en.wikipedia.org/wiki/Antarctica"
        static let objectId: String = "1c31c3b@by"
        static let uniqueKey: String = "duhduhduhduhduh"
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
    }
    
    var name: String { return "\(firstName) \(lastName)" }
    
    init(firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, objectId: String, uniqueKey: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? Default.firstName
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? Default.lastName
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? Default.latitude
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? Default.longitude
        let mapString = try container.decodeIfPresent(String.self, forKey: .mapString) ?? Default.mapString
        let mediaURL = try container.decodeIfPresent(String.self, forKey: .mediaURL) ?? Default.mediaURL
        let objectId = try container.decodeIfPresent(String.self, forKey: .objectId) ?? Default.objectId
        let uniqueKey = try container.decodeIfPresent(String.self, forKey: .uniqueKey) ?? Default.uniqueKey
        
        self.firstName = (firstName != "") ? firstName : Default.firstName
        self.lastName = (lastName != "") ? lastName : Default.lastName
        self.mapString = (mapString != "") ? mapString : Default.mapString
        self.mediaURL = (mediaURL != "") ? mediaURL : Default.mediaURL
        self.objectId = (objectId != "") ? objectId : Default.objectId
        self.uniqueKey = (uniqueKey != "") ? uniqueKey : Default.uniqueKey
    }
}
