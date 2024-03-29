//
//  MarkMKAnnotation.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import Foundation
import MapKit

final class MarkMKAnnotation: NSObject {
    
    private let annotation: MarkAnnotation
    
    init(annotation: MarkAnnotation) {
        self.annotation = annotation

        super.init()
    }
}

extension MarkMKAnnotation {
    
    var markID: String {
        return annotation.id
    }
    
    var pinColor: UIColor {
        switch annotation.classification {
        case .others:
            return .yellow
        case .owned:
            return .red
        }
    }
}


// MARK: - MKAnnotation

extension MarkMKAnnotation: MKAnnotation {
    
    var title: String? {
        return annotation.title
    }
    
    var subtitle: String? {
        return annotation.subtitle
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: annotation.location.latitude,
            longitude: annotation.location.longtitue
        )
    }
}
