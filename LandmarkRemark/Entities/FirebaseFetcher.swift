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

extension FirebaseFetcher {
    
    enum FirebaseError: Error {
        
        case failInitialization
    }
    
    enum Endpoint: String {
        
        case users, marks
    }
    
    private enum Key: String {
        
        case userUniqueIdentifier
    }
}

final class FirebaseFetcher {
    
    static var owner: Single<User?> {
        return .create { observer in
            reference.child(Endpoint.users.rawValue).child(FirebaseFetcher.userIdentifier)
                .observe(.value) { snapshot in
                    if  let value = snapshot.value as? [String: Any],
                        let name = value[User.Key.name.rawValue] as? String
                    {
                        observer(.success(User(id: snapshot.key, name: name)))
                    } else {
                        observer(.success(nil))
                    }
            }
            
            return Disposables.create()
        }
    }
    
    static var users: Single<[User]> {
        return .create { observer in
            reference.child(Endpoint.users.rawValue)
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
    
    static var markers: Single<[Mark]> {
        return .create { observer in
            reference.child(Endpoint.marks.rawValue)
                .observeSingleEvent(of: .value) { snapshot in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let markers = dictionary
                            .compactMap { Mark(id: $0.key, dictionary: $0.value as? [String: Any]) }
                        observer(.success(markers))
                    } else {
                        observer(.error(FirebaseError.failInitialization))
                    }
            }
            
            return Disposables.create()
        }
    }
    
    static func storeUser(name: String) {
        DispatchQueue.global(qos: .background).async {
            reference.child(Endpoint.users.rawValue).child(FirebaseFetcher.userIdentifier)
                .updateChildValues([User.Key.name.rawValue: name])
        }
    }
    
    static func storeMarker(date: Date, location: Location, comment: String) {
        DispatchQueue.global(qos: .background).async {
            let values: [String: Any] = [
                Mark.Key.userID.rawValue: FirebaseFetcher.userIdentifier,
                Mark.Key.latitude.rawValue: location.latitude,
                Mark.Key.longtitue.rawValue: location.longtitue,
                Mark.Key.note.rawValue: comment,
                Mark.Key.createdDate.rawValue: date.timeIntervalSince1970
            ]
            reference.child(Endpoint.marks.rawValue).childByAutoId()
                .updateChildValues(values)
        }
    }
    
    private static let reference = Database.database().reference()
    
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
}

