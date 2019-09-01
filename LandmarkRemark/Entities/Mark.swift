//
//  Mark.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import Foundation

struct Mark {
    
    enum Key: String {
        
        case userID, note
        case longtitue, latitude, createdDate
    }
    
    let id: String
    let userID: String
    let note: String
    let location: Location
    let createdDate: Date
    
    init?(id: String, dictionary: [String: Any]?) {
        guard
            let userID = dictionary?[Key.userID.rawValue]  as? String,
            let latitude = dictionary?[Key.latitude.rawValue] as? Double,
            let longtitue = dictionary?[Key.longtitue.rawValue] as? Double,
            let note = dictionary?[Key.note.rawValue] as? String,
            let createdTimeIntervale = dictionary?[Key.createdDate.rawValue] as? Double
        else { return nil }
        
        self.id = id
        self.userID = userID
        self.location = Location(longtitue: longtitue, latitude: latitude)
        self.note = note
        self.createdDate = Date(timeIntervalSince1970: createdTimeIntervale)
    }
    
    init(id: String, userID: String, note: String, longtitue: Double, latitude: Double, createdDate: Double) {
        self.id = id
        self.userID = userID
        self.location = Location(longtitue: longtitue, latitude: latitude)
        self.note = note
        self.createdDate = Date(timeIntervalSince1970: createdDate)
    }
}
