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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        view.addSubview(searchBar)
        
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
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func prepareBindings() {
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
        
        
    }
}
