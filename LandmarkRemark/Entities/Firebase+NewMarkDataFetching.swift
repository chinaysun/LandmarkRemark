//
//  Firebase+NewMarkDataFetching.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import Foundation

protocol NewMarkDataFetching {
    
    func storeMarker(date: Date, location: Location, comment: String)
}

extension FirebaseFetcher: NewMarkDataFetching {
    
    func storeMarker(date: Date, location: Location, comment: String) {
        FirebaseFetcher.storeMarker(date: date, location: location, comment: comment)
    }
}
