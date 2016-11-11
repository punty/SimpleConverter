//
//  UITableView+ItemCell.swift
//  SimpleShopping
//
//  Created by Francesco Puntillo on 19/09/2016.
//  Copyright © 2016 punty. All rights reserved.
//

import UIKit

//This extension add a convenience method to create a cell
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: ItemCellType {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            //The impossible happened
            fatalError("Wrong Cell Type")
        }
        return cell
    }
}
