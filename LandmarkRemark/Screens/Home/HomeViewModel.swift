//
//  HomeViewModel.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 30/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import RxSwift

final class HomeViewModel {
    
    // MARK: - Data Injection
    
    private let coreLocationManager: CoreLocationManaging


    // MARK: - Observables
    
    var screenTitle: Observable<String> { return .just("LandmarkRemark") }
    
    var isUserLocationShown: Observable<Bool> {
        return coreLocationManager.authorizationStatus
            .map { $0 == .authorizedAlways || $0 == .authorizedWhenInUse }
            .distinctUntilChanged()
    }
    
    init(coreLocationManager: CoreLocationManaging = CoreLocationManager()) {
        self.coreLocationManager = coreLocationManager
    }
}

// MARK: - Public Function

extension HomeViewModel {
    
    func loadUserLocation() {
        coreLocationManager.requestPermissionIfNeeded()
        coreLocationManager.startUpdatingLocation()
    }
}
