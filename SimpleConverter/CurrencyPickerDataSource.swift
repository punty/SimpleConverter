//
//  CurrencyPickerDataSource.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 14/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import  UIKit

final class CurrencyPickerDataSource:NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let currencies: [String]
    
    var callback:(String) ->()
    
    init(currencies: [String], callback:@escaping (String)->()) {
        self.currencies = currencies
        self.callback = callback
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        callback(currencies[row])
    }
    
    func currency(at: Int) -> String? {
        if at >= 0 && at < currencies.count {
            return currencies[at]
        }
        return nil
    }
    
    func index(of: String) -> Int? {
        return currencies.index(of: of)
    }
}

