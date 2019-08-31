//
//  User.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

struct User {
    
    enum Key: String {
        
        case name
    }
    
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init?(id: String, dictionary: [String: Any]?) {
        guard let name = dictionary?[Key.name.rawValue] as? String
        else { return nil }
        
        self.id = id
        self.name = name
    }
}
