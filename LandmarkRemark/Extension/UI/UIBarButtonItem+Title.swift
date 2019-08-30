//
//  UIBarButtonItem+Title.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    convenience init(title: String) {
        self.init(title: title, style: .plain, target: nil, action: nil)
    }
}
