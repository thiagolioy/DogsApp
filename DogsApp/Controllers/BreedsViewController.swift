//
//  FirstViewController.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit

final class BreedsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let service: DogsService = DogsAPI()
    var breeds: [Breed] = [] {
        didSet {
            setupDatasource()
        }
    }
    
    var filterBy: String? = nil {
        didSet {
            setupDatasource()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        fetchBreeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Por que estou fazendo isso no view will appear ?
        navigationItem.title = "Breeds"
    }

    func fetchBreeds() {
        tableView.isHidden = true
        activityIndicator.startAnimating()
        service.fetchBreeds { breeds in
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.breeds = breeds
        }
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setupDatasource() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.reloadData()
    }
    
    func filteredBreeds() -> [Breed] {
        guard let filterBy = self.filterBy else {
            return breeds
        }
        return breeds.filter { $0.name.lowercased().starts(with: filterBy.lowercased()) }
    }
    
}

extension BreedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBreeds().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let breed = filteredBreeds()[indexPath.row]
        cell.textLabel?.text = breed.name
        return cell
    }
}

extension BreedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breed = filteredBreeds()[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            proceedToBreedImagesViewCode(breed: breed)
        } else {
            proceedToBreedImagesStoryboard(breed: breed)
        }
        
    }
    
    func proceedToBreedImagesViewCode(breed: Breed) {
        
    }
    
    func proceedToBreedImagesStoryboard(breed: Breed) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "BreedImagesStoryboardViewController") as? BreedImagesStoryboardViewController else {
            return
        }
        controller.breed = breed
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension BreedsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterBy = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterBy = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


