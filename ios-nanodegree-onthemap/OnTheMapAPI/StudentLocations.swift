//
//  StudentLocations.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import Foundation

struct StudentLocations: Codable {
    var results: [StudentLocation]
    var count: Int { return results.count }
    private var index = 0 // used in iterator
    static var shared = StudentLocations()
    
    subscript(index: Int) -> StudentLocation {
        get {
            return results[index]
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    private init() {
        self.results = []
    }
}

extension StudentLocations: Sequence, IteratorProtocol {
    mutating func next() -> StudentLocation? {
        defer { index += 1 }
        
        if index < results.count {
            return results[index]
        }
        
        return nil
    }
}
