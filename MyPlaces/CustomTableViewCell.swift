//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Григорий Душин on 03.09.2022.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet{
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height/2
            imageOfPlace.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    
    @IBOutlet weak var typeLabel: UILabel!
}
