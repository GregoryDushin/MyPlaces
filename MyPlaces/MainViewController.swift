//
//  ViewController.swift
//  MyPlaces
//
//  Created by Григорий Душин on 30.08.2022.
//

import UIKit

class MainViewController: UITableViewController {
  
    let restaurantNames = ["Burger Heroes", "Mambo Djambo","Bella Vito", "Il Patio", "Chinese News", "Hot Beef"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

//MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = restaurantNames[indexPath.row]
        cell?.imageView?.image = UIImage(named: restaurantNames[indexPath.row])
        
        return cell!
    }
}

