//
//  Views+Reusable.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import UIKit
import MapKit

protocol ReusableView: class {
    
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    
    static var defaultReuseIdentifier: String {
        return String(describing: self.self)
    }
}

extension UICollectionReusableView: ReusableView {}
extension UITableViewCell: ReusableView {}
extension MKAnnotationView: ReusableView {}

