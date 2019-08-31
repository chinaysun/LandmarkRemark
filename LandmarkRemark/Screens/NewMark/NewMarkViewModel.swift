//
//  NewMarkViewModel.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import Foundation
import RxSwift

final class NewMarkViewModel {
    
    private let location: Location
    private let dataFetcher: NewMarkDataFetching
    private let date = Date()
    
    var screenTitle: Observable<String> {
        return .just(DateFormatter.landmarkRemarkDateFormatter.string(from: date))
    }
    
    init(
        location: Location,
        dataFetcher: NewMarkDataFetching = FirebaseFetcher()
    ) {
        self.location = location
        self.dataFetcher = dataFetcher
    }
    
    func saveComment(_ comment: String) {
        guard !comment.isEmpty else { return }
        
        dataFetcher.storeMarker(date: date, location: location, comment: comment)
    }
}
