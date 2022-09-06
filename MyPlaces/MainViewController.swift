//
//  ViewController.swift
//  MyPlaces
//
//  Created by Григорий Душин on 30.08.2022.
//

import UIKit

class MainViewController: UITableViewController {
  

    let places = Place.getPlaces()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

//MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        cell.nameLabel.text = places[indexPath.row].name
        cell.imageOfPlace.image = UIImage(named: places[indexPath.row].image)
        cell.locationLabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height/2
        cell.imageOfPlace.clipsToBounds = true
        
        return cell
    }
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {
        
    }

}

