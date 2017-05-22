//
//  Country.swift
//  FireWarden
//
//  Created by Paul Keller on 22/05/2017.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Country {
    var countryID: Int32
    var country: String
    
    init(){
        self.countryID = 0
        self.country = ""
    }
    
    init(CountryID: Int32, Country: String) {
        self.countryID=CountryID
        self.country=Country
    }
}
