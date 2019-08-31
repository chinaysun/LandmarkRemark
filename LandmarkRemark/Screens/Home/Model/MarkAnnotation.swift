//
//  MarkAnnotation.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import Foundation

extension MarkAnnotation {
    
    enum Classification {
        
        case owned, others
    }
}

struct MarkAnnotation {
    
    let id: String
    let classification: Classification
    let title: String?
    let subtitle: String?
    let location: Location
}

extension MarkAnnotation: Equatable {
    
    static func == (lhs: MarkAnnotation, rhs: MarkAnnotation) -> Bool {
        return lhs.id == rhs.id
    }
}
