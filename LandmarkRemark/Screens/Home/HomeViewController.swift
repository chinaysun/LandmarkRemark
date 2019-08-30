//
//  HomeViewController.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 30/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import MapKit
import RxCocoa
import RxSwift
import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private let horizontalPadding: CGFloat = 16
    private let buttonWidth: CGFloat = 35
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .standard
        
        return map
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    private lazy var compassButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "mapCompassIcon"), for: .normal)
        
        return button
    }()
    
    private lazy var markButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "mapMarkIcon"), for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        view.addSubview(searchBar)
        view.addSubview(compassButton)
        view.addSubview(markButton)
        
        layout()
        prepareBindings()
        
        viewModel.loadUserLocation()
    }
}


// MARK: - Preparation

private extension HomeViewController {
    
    func layout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeights),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            compassButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            compassButton.heightAnchor.constraint(equalToConstant: buttonWidth),
            compassButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -horizontalPadding),
            compassButton.bottomAnchor.constraint(equalTo: viewSafeBottomAnchor),
            markButton.centerYAnchor.constraint(equalTo: compassButton.centerYAnchor),
            markButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            markButton.heightAnchor.constraint(equalToConstant: buttonWidth),
            markButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalPadding)
        ])
    }
    
    func prepareBindings() {
        prepareViewModelBindings()
        prepareUIBindings()
    }
    
    func prepareViewModelBindings() {
        viewModel.screenTitle
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.isUserLocationShown
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.mapView.showsUserLocation = $0
                if $0 { self?.viewModel.loadUserLocation() }
            })
            .disposed(by: disposeBag)
        
        viewModel.userCurrentLocation
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.moveMapTo($0.coordinate)
            })
            .disposed(by: disposeBag)
    }
    
    func prepareUIBindings() {
        compassButton.rx.tap
            .withLatestFrom(viewModel.userCurrentLocation)
            .subscribe(onNext: { [weak self] in
                self?.moveMapTo($0.coordinate)
            })
            .disposed(by: disposeBag)
        
        markButton.rx.tap
            .withLatestFrom(viewModel.userCurrentLocation)
            .subscribe(onNext: { [weak self] in
                self?.remakerMap(on: $0.coordinate)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - UI Functions

private extension HomeViewController {
    
    func moveMapTo(_ center: CLLocationCoordinate2D) {
        let regionInMeters: Double = 1000
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: regionInMeters,
            longitudinalMeters: regionInMeters
        )
        
        mapView.setRegion(region, animated: true)
    }
    
    func remakerMap(on coordinate: CLLocationCoordinate2D) {
        let targetLocation = Location(longtitue: coordinate.longitude, latitude: coordinate.latitude)
        let viewController = NewMarkViewController(location: targetLocation)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
