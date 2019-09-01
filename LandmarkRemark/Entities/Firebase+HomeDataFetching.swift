//
//  Firebase+HomeDataFetching.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import RxSwift

extension FirebaseFetcher: HomeDataFetching {
    
    var owner: Single<User?> {
        return FirebaseFetcher.owner
    }

    var users: Single<[User]> {
        return FirebaseFetcher.users
    }
    
    var markers: Single<[Mark]> {
        return FirebaseFetcher.markers
    }
    
    func storeUser(name: String) {
        FirebaseFetcher.storeUser(name: name)
    }
}
