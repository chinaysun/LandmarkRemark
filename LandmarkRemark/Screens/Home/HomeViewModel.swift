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
    private let marksSink = BehaviorSubject<[Mark]>(value: [])
    private let usersSink = BehaviorSubject<[User]>(value: [])
    private let searchSink = PublishSubject<String?>()
    private let markSelectedSink = PublishSubject<String>()
    
    private let dateFomatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter
    }()

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
    
    var annotations: Observable<[MarkAnnotation]> {
        return Observable
            .combineLatest(
                marksSink.filterEmpty(),
                usersSink.filterEmpty(),
                ownerSink,
                searchSink.startWith(nil)
            ) { ($0, $1, $2, $3) }
            .map { [weak self] marks, users, deviceOwner, filter -> [MarkAnnotation] in
                let targetIDs = self?.targetIDs(filter: filter, marks: marks, users: users)

                return marks.compactMap {
                    self?.makeMarkAnnotation(
                        mark: $0,
                        users: users,
                        deviceOwner: deviceOwner,
                        targetIDs: targetIDs
                    )
                }
            }
            .filterEmpty()
            .distinctUntilChanged()
    }
    
    var viewMark: Observable<MarkDetailViewControllerModel> {
        return markSelectedSink
            .withLatestFrom(marksSink) { ($0, $1) }
            .compactMap { selectedID, marks -> Mark? in
                return marks.first { selectedID == $0.id }
            }
            .withLatestFrom(usersSink) { ($0, $1) }
            .map { [weak self] mark, users -> MarkDetailViewControllerModel in
                let author = users.first { $0.id == mark.userID }
                let deviceOwner = self?.ownerSink.value
                let authorName = author?.id == deviceOwner?.id
                    ? "You"
                    : author?.name
                
                return MarkDetailViewControllerModel(
                    heading: DateFormatter.landmarkRemarkDateFormatter.string(from: mark.createdDate),
                    title: "\(authorName ?? "Unknown Author") comments this location",
                    note: mark.note
                )
            }
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
    
    func loadAnnotations() {
        dataFetcher.markers
            .catchErrorJustReturn([])
            .subscribe(onSuccess: { [weak self] in
                self?.marksSink.onNext($0)
            })
            .disposed(by: disposeBag)
        
        dataFetcher.users
            .catchErrorJustReturn([])
            .subscribe(onSuccess: { [weak self] in
                self?.usersSink.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
    func saveOwner(name: String) {
        dataFetcher.storeUser(name: name)
    }
    
    func selectMark(id: String) {
        markSelectedSink.onNext(id)
    }
    
    func search(target: String?) {
        searchSink.onNext(target)
    }
}


// MARK: - Private Functions

private extension HomeViewModel {
    
    func makeMarkAnnotation(
        mark: Mark,
        users: [User],
        deviceOwner: User?,
        targetIDs: [String]?
    ) -> MarkAnnotation? {
        let shouldCreate = targetIDs == nil
            || targetIDs?.contains(mark.id) == true
            || targetIDs?.isEmpty == true
        
        guard shouldCreate else { return nil }
        
        let author = users.first { $0.id == mark.userID }
        let authorName = author?.name ?? "Unknown"
        let date = dateFomatter.string(from: mark.createdDate)
        let isOwner = author?.id == deviceOwner?.id

        return MarkAnnotation(
            id: mark.id,
            classification: isOwner ? .owned : .others,
            title: "\(date)",
            subtitle: "\(authorName) says: \(mark.note)",
            location: mark.location
        )
    }
    
    func targetIDs(filter: String?, marks: [Mark], users: [User]) -> [String]? {
        guard let filter = filter?.lowercased(), !filter.isEmpty else { return nil }
        
        return marks
            .filter { mark -> Bool in
                let author = users.first { $0.id == mark.userID }
                return author?.name.lowercased().contains(filter) == true
                    || mark.note.lowercased().contains(filter)
            }
            .map { $0.id }
    }
}
