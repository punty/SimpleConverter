//
//  ConverterViewController.swift
//  SimpleConverter
//
//  Created by Francesco Puntillo on 11/11/2016.
//  Copyright © 2016 Francesco Puntillo. All rights reserved.
//

import UIKit
import SimpleNetworking
import RxSwift
import RxCocoa


class ConverterViewController: UIViewController {

    //outlets
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var toCurrencyTextField: UITextField!
    @IBOutlet weak var toValueTextField: UITextField!
    @IBOutlet weak var fromValueTextField: UITextField!
    
    let disposeBag = DisposeBag()
    
    //this is just a quick solution for the assignment in a real app i will handle dependecy properly
    let converterService = ConversionService(serviceClient: ServiceClient())
    var viewModel: ConverterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ConverterViewModel (input:
            (fromCurrency: fromCurrencyTextField.rx.text.orEmpty.asDriver(),
             toCurrency: toCurrencyTextField.rx.text.orEmpty.asDriver(),
             fromValue: fromValueTextField.rx.text.orEmpty.asDriver(),
             toValue: toValueTextField.rx.text.orEmpty.asDriver()
            )
            , service: converterService)
        
        viewModel.fromCurrencyDriver.drive(fromValueTextField.rx.text).addDisposableTo(disposeBag)
        viewModel.toCurrencyDriver.drive(toValueTextField.rx.text).addDisposableTo(disposeBag)
    }

}
