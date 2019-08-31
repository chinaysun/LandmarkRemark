//
//  HomeViewModel.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 30/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import CoreLocation
import RxRelay
import RxSwift

final class HomeViewModel {
    
    // MARK: - Data Injection
    
    private let coreLocationManager: CoreLocationManaging
    private let dataFetcher: HomeDataFetching
    
    private let disposeBag = DisposeBag()
    private let ownerSink = BehaviorRelay<User?>(value: nil)

    // MARK: - Observables
    
    var screenTitle: Observable<String> {
        return ownerSink
            .map {
                if let name = $0?.name {
                    return name
                } else {
                    return "Landmark Remark"
                }
            }
    }
    
    var userCurrentLocation: Observable<CLLocation> {
        return coreLocationManager.didUpdateLocation
    }
    
    var isUserLocationShown: Observable<Bool> {
        return coreLocationManager.authorizationStatus
            .map { $0 == .authorizedAlways || $0 == .authorizedWhenInUse }
            .distinctUntilChanged()
    }
    
    var isOwnerExists: Observable<Bool> {
        return ownerSink.map { $0 != nil }
    }
    
    init(
        coreLocationManager: CoreLocationManaging = CoreLocationManager(),
        dataFetcher: HomeDataFetching = FirebaseFetcher()
    ) {
        self.coreLocationManager = coreLocationManager
        self.dataFetcher = dataFetcher
    }
}

// MARK: - Public Function

extension HomeViewModel {
    
    func loadOwner() {
        guard ownerSink.value == nil else { return }
        
        dataFetcher.owner
            .catchErrorJustReturn(nil)
            .subscribe(onSuccess: { [weak self] in
                self?.ownerSink.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func loadUserLocation() {
        coreLocationManager.requestPermissionIfNeeded()
        coreLocationManager.startUpdatingLocation()
    }
    
    func saveOwner(name: String) {
        dataFetcher.storeUser(name: name)
    }
}
