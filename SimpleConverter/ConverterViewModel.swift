//
//  ConverterViewModel.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 11/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SimpleNetworking

protocol ViewControllerViewModelType {
    var title: Driver<String> { get }
}

protocol ConverterViewModelType: ViewControllerViewModelType {
    
    //input
    var fromCurrency: Driver<String> { get }
    var toCurrency: Driver<String> { get }
    var fromValue: Driver<String> { get }
    var toValue: Driver<String> { get }
    var rate: Variable<Double?> { get }
    
    //output
    var toCurrencyDriver: Driver<String> { get }
    var fromCurrencyDriver: Driver<String> { get }
}

final class ConverterViewModel: ConverterViewModelType {
    
    var title: Driver<String> = .just("Simple Converter")
    let disposeBag = DisposeBag()
    
    var fromCurrency: Driver<String>
    var toCurrency: Driver<String>
    var fromValue: Driver<String>
    var toValue: Driver<String>
    var rate: Variable<Double?>
    
    //output
    var toCurrencyDriver: Driver<String>
    var fromCurrencyDriver: Driver<String>
    var currencies: Variable<ConversionData?>
    
    var service: ConversionServiceProtocol
    
    init(
        input: (
            fromCurrency: Driver<String>,
            toCurrency: Driver<String>,
            fromValue: Driver<String>,
            toValue: Driver<String>
        ),
        service: ConversionServiceProtocol) {
        
        currencies = Variable<ConversionData?>(nil)
        fromCurrency = input.fromCurrency
        toCurrency = input.toCurrency
        fromValue = input.fromValue
        toValue = input.toValue
        rate = Variable<Double?> (nil)
        
        let rateDriver = rate.asDriver()
        
        Driver.combineLatest(fromCurrency, toCurrency, currencies.asDriver()) {
            from, to, data in
            if let data = data {
                do {
                   let rate = try data.graphView.shortestPath(from: from, to: to)
                    if rate.isFinite {
                        return exp2(rate)
                    }
                    return 0.0
                } catch {
                    return 0.0
                }
            }
            return 0.0
        }.drive(rate).addDisposableTo(disposeBag)
        
        toCurrencyDriver = Driver.combineLatest(fromValue, rateDriver) {
            from, rate in
            let fromValue = Double(from)
            if let fromValue = fromValue, let rate = rate {
                if fromValue.isFinite {
                     return String (format:"%.2f",fromValue * rate)
                }
              
            }
            return "---"
        }
        
        fromCurrencyDriver = Driver.combineLatest(toValue, rateDriver) {
            from, rate in
            let fromValue = Double(from)
            if let fromValue = fromValue, let rate = rate {
                if fromValue.isFinite && rate > 0 {
                    return String (format:"%.2f",fromValue / rate)
                }
            }
            return "---"
        }
        
        self.service = service
        
        service.conversionData {
            [weak self] data in
            guard let `self` = self else {
                return
            }
            if let data = data {
                self.currencies.value = data
            }
        }
    }
}
