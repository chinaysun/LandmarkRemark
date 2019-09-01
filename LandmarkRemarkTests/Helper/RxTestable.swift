//
//  RxTestable.swift
//  LandmarkRemarkTests
//
//  Created by Yu Sun on 1/9/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import RxSwift
import RxTest
import XCTest

protocol RxTestable {
    
    var scheduler: TestScheduler { get }
    var disposeBag: DisposeBag { get }
}

extension RxTestable where Self: XCTestCase {
    
    func createTestableObserver<T>(on observable: Observable<T>) -> TestableObserver<T> {
        let observer = scheduler.createObserver(T.self)
        
        observable
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        return observer
    }
}
