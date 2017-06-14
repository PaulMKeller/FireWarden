//
//  Person.swift
//  FireWarden
//
//  Created by Paul Keller on 14/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Person {
    var personID: Int32 = 0
    var firstName: String = ""
    var lastName: String = ""
    var gender: String = ""
    var personLocation = Location()
    
    init() {
        self.personID = 0
        self.firstName = ""
        self.lastName = ""
        self.gender = ""
        self.personLocation = Location()
    }
    
    init(personID: Int32, firstName: String, lastName: String, gender: String, personLocation: Location) {
        self.personID = personID
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.personLocation = personLocation
    }
}
