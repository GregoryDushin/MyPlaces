//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Григорий Душин on 06.09.2022.
//

import Foundation
import UIKit
import RealmSwift
import Realm

class Place : Object {
    @objc dynamic var name = ""
    @objc dynamic var location : String?
    @objc dynamic var type : String?
    @objc dynamic var imageData: Data?
    
    convenience init(name: String , location: String? , type: String? , imageData : Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
    
    
}
