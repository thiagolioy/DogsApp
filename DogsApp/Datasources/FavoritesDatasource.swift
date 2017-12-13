//
//  FavoritesDatasource.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit

final class FavoritesDatasource: NSObject, UITableViewDataSource {
    let dogs: [Dog]
    
    init(tableView: UITableView, dogs: [Dog]) {
        self.dogs = dogs
        super.init()
        register(in: tableView)
    }
    
    func register(in tableView: UITableView) {
        tableView.register(cellType: FavoriteDogTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: FavoriteDogTableViewCell.self)
        let dog = dogs[indexPath.row]
        cell.setup(dog: dog)
        return cell
    }
}
