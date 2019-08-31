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
    
    let annotation: MarkAnnotation
    
    init(annotation: MarkAnnotation) {
        self.annotation = annotation

        super.init()
    }
}

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
