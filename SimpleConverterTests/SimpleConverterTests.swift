//
//  SimpleConverterTests.swift
//  SimpleConverterTests
//
//  Created by Francesco Puntillo on 14/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import SimpleConverter


class SimpleConverterTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    func testToCurrencyDriver() {
       let scheduler = TestScheduler(initialClock: 0)
       let observerTo = scheduler.createObserver(String.self)
       let observerFrom = scheduler.createObserver(String.self)
        
       let viewModel = ConverterViewModel (input:
            (fromCurrency: .just("EUR"),
             toCurrency: .just("EUR"),
             fromValue: .just("10.0"),
             toValue: .just("10.0")
            )
            , service: ServiceMock(fileName: "currency"))
        
        viewModel.toCurrencyDriver.asObservable().subscribe(observerTo).addDisposableTo(disposeBag)
        viewModel.toCurrencyDriver.asObservable().subscribe(observerFrom).addDisposableTo(disposeBag)
        XCTAssert( observerTo.events.count == 1)
        XCTAssert( observerFrom.events.count == 1)
        let correctValues = [
            next(0, "10.00")
        ]
        XCTAssertEqual(observerTo.events, correctValues)
        XCTAssertEqual(observerFrom.events, correctValues)
    }
}
