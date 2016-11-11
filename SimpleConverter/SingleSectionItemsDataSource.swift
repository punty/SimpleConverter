//
//  SingleSectionItemsDataSource.swift
//  SimpleShopping
//
//  Created by Francesco Puntillo on 19/09/2016.
//  Copyright © 2016 punty. All rights reserved.
//

import UIKit

final class SingleSectionItemsDataSource <T: UITableViewCell>:NSObject, UITableViewDataSource where T:ItemCellType {
    
    var items: [T.ViewModel]
    
    override init() {
        self.items = []
    }
    
    init (items:[T.ViewModel]) {
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(indexPath: indexPath) as T
        cell.updateViewModel(viewModel: items[indexPath.row])
        return cell
    }
}
