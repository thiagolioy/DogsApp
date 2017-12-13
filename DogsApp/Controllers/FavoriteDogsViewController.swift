//
//  SecondViewController.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit

final class FavoriteDogsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var datasource: FavoritesDatasource?
    let dogPersistence: DogPersistenceService = DogMemoryCrud.instance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDatasource()
    }
    
    func setupDatasource() {
        datasource = FavoritesDatasource(tableView: tableView, dogs: dogPersistence.dogs())
        tableView.dataSource = datasource
        tableView.rowHeight = 120
        tableView.reloadData()
    }

  

}

