//
//  FirebaseFetcher.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift

protocol FirebaseFetching {
    
    var users: Single<[User]> { get }
    var markers: Single<[Marker]> { get }
    
    func storeUser(name: String)
    func storeMarker(date: Date, location: Location, comment: String)
}

final class FirebaseFetcher {
    
    private enum Key: String {
        
        case userUniqueIdentifier
    }
    
    private static var userIdentifier: String {
        if let id = UIDevice.current.identifierForVendor {
            return id.uuidString
        } else if let id = UserDefaults.standard.string(forKey: Key.userUniqueIdentifier.rawValue) {
            return id
        } else {
            let id = UUID().uuidString
            UserDefaults.standard.setValue(id, forKey: Key.userUniqueIdentifier.rawValue)
            UserDefaults.standard.synchronize()
            return id
        }
    }
    
    private let reference = Database.database().reference()
}

extension FirebaseFetcher {
    
    enum FirebaseError: Error {
        
        case failInitialization
    }
    
    private enum Endpoint: String {
        
        case users, marks
    }
}

extension FirebaseFetcher: FirebaseFetching {
    
    var users: Single<[User]> {
        return .create { [weak self] observer in
            self?.reference.child(Endpoint.users.rawValue)
                .observeSingleEvent(of: .value) { snapshot in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let users = dictionary
                            .compactMap { User(id: $0.key, dictionary: $0.value as? [String: Any]) }
                        observer(.success(users))
                    } else {
                        observer(.error(FirebaseError.failInitialization))
                    }
            }
            
            return Disposables.create()
        }
    }
    
    var markers: Single<[Marker]> {
        return .create { [weak self] observer in
            self?.reference.child(Endpoint.marks.rawValue)
                .observeSingleEvent(of: .value) { snapshot in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let markers = dictionary
                            .compactMap { Marker(id: $0.key, dictionary: $0.value as? [String: Any]) }
                        observer(.success(markers))
                    } else {
                        observer(.error(FirebaseError.failInitialization))
                    }
            }
            
            return Disposables.create()
        }
    }
    
    func storeUser(name: String) {
        DispatchQueue.global(qos: .background).async {
            self.reference.child(Endpoint.users.rawValue).child(FirebaseFetcher.userIdentifier)
                .updateChildValues([User.Key.name.rawValue: name])
        }
    }
    
    func storeMarker(date: Date, location: Location, comment: String) {
        DispatchQueue.global(qos: .background).async {
            let values: [String: Any] = [
                Marker.Key.userID.rawValue: FirebaseFetcher.userIdentifier,
                Marker.Key.latitude.rawValue: location.latitude,
                Marker.Key.longtitue.rawValue: location.longtitue,
                Marker.Key.note.rawValue: comment,
                Marker.Key.createdDate.rawValue: date.timeIntervalSince1970
            ]
            self.reference.child(Endpoint.marks.rawValue).childByAutoId()
                .updateChildValues(values)
        }
    }
}
