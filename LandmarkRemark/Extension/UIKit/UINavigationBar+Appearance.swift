//
//  UINavigationBar+Appearance.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    static func configureAppearance() {
        let appearance = UINavigationBar.appearance()
        
        let navigationBarTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        appearance.shadowImage = UIImage()
        appearance.barTintColor = .orange
        appearance.titleTextAttributes = navigationBarTitleAttributes
        appearance.tintColor = .white
        appearance.isTranslucent = false
        appearance.backIndicatorImage = #imageLiteral(resourceName: "navigationBackIcon")
        appearance.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "navigationBackIcon")
        appearance.barStyle = .blackTranslucent
    }
}
