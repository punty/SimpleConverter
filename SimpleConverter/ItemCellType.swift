//
//  ItemCellType.swift
//  SimpleShopping
//
//  Created by Francesco Puntillo on 19/09/2016.
//  Copyright © 2016 punty. All rights reserved.
//

import Foundation

protocol ItemCellType: class {
    
    associatedtype ViewModel
    
    func updateViewModel(viewModel: ViewModel)
    static var reuseIdentifier: String { get }
}

// Most of the time I will use the class name as Reuse identifier.
// That's why I decided to put this into an extension
extension ItemCellType {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}
