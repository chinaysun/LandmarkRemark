//
//  CoreLocationManager.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 30/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import CoreLocation
import RxRelay
import RxSwift

protocol CoreLocationManaging {
    
    var isLocationServiceEnabled: Observable<Bool> { get }
    var authorizationStatus: Observable<CLAuthorizationStatus> { get }
    var didUpdateLocation: Observable<CLLocation> { get }
    
    func requestPermissionIfNeeded()
    func startUpdatingLocation()
}

final class CoreLocationManager: NSObject {
    
    private let isEnabledSink = BehaviorRelay<Bool>(value: CLLocationManager.locationServicesEnabled())
    private let statusSink = BehaviorRelay<CLAuthorizationStatus>(value: CLLocationManager.authorizationStatus())
    private let updateLocationSink = PublishSubject<CLLocation>()
    
    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        return manager
    }()
}


// MARK: - CLLocationManagerDelegate

extension CoreLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateLocationSink.onNext(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        statusSink.accept(status)
    }
}


// MARK: - Core Location Managing

extension CoreLocationManager: CoreLocationManaging {
    
    var isLocationServiceEnabled: Observable<Bool> {
        return isEnabledSink.asObservable()
    }
    
    var authorizationStatus: Observable<CLAuthorizationStatus> {
        return statusSink.asObservable()
    }
    
    var didUpdateLocation: Observable<CLLocation> {
        return updateLocationSink
    }
    
    func requestPermissionIfNeeded() {
        guard statusSink.value == .notDetermined && isEnabledSink.value else { return }
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
}
