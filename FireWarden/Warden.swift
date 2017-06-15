//
//  Warden.swift
//  FireWarden
//
//  Created by Paul Keller on 15/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Warden {
    var wardenID: Int32
    var wardenPerson: Person
    var wardenLocation: Location
    
    init() {
        self.wardenID = 0
        self.wardenPerson = Person()
        self.wardenLocation = Location()
    }
    
    init(wardenID: Int32, wardenPerson: Person, wardenLocation: Location) {
        self.wardenID = wardenID
        self.wardenPerson = wardenPerson
        self.wardenLocation = wardenLocation
    }
}
