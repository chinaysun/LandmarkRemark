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
    private let date = Date()
    
    var screenTitle: Observable<String> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return .just(dateFormatter.string(from: date))
    }
    
    init(location: Location) {
        self.location = location
    }
    
    func saveComment(_ comment: String) {
        guard !comment.isEmpty else { return }
        
    }
}
