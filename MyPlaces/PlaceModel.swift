//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Григорий Душин on 06.09.2022.
//

import Foundation

struct Place {
    var name : String
    var location : String
    var type : String
    var image : String
    
   static let restaurantNames = ["Burger Heroes", "Mambo Djambo","Bella Vito", "Il Patio", "Chinese News", "Hot Beef"]
    
   static func getPlaces() -> [Place] {
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Moscow", type: "Restaurant", image: place))
        }
        return places
    }
    
}