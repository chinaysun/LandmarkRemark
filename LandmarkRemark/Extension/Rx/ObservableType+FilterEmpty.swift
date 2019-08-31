//
//  ObservableType+FilterEmpty.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 31/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//
//  Note: Please refer to: https://github.com/RxSwiftCommunity/RxOptional
//  this is an idea how to generic filter empty function, we can consider
//  to import RxOptional into our project if we found there is more codes will be used


import Foundation
import RxSwift

protocol Occupiable {
    
    var isEmpty: Bool { get }
}

extension Array: Occupiable { }

extension ObservableType where Element: Occupiable {

    func filterEmpty() -> Observable<Element> {
        return self.flatMap { element -> Observable<Element> in
            guard !element.isEmpty else {
                return Observable<Element>.empty()
            }
            return Observable<Element>.just(element)
        }
    }
}
