//
//  Location.swift
//  FireWarden
//
//  Created by Paul Keller on 19/5/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Location {
    var locationID: Int32 = 0
    var locationName: String = ""
    var floor: String = ""
    var countryID: Int32 = 0
    var country: String = ""
    
    init(locationID: Int32, locationName: String, floor: String, countryID: Int32, country: String) {
        self.locationID = locationID
        self.locationName = locationName
        self.floor = floor
        self.countryID = countryID
        self.country = country
    }
}
