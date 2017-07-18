//
//  WardenCount.swift
//  FireWarden
//
//  Created by Paul Keller on 18/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class WardenCount {
    var wardenID: Int32 = 0
    var firstName: String = ""
    var lastName: String = ""
    var personCount: Int32 = 0
    var sectionNumber: Int32 = 0
    
    init(){
        self.wardenID = 0
        self.firstName = ""
        self.lastName = ""
        self.personCount = 0
        self.sectionNumber = 0
    }
    
    init(wardenID: Int32, firstName: String, lastName: String, personCount: Int32, sectionNumber: Int32) {
        self.wardenID = wardenID
        self.firstName = firstName
        self.lastName = lastName
        self.personCount = personCount
        self.sectionNumber = sectionNumber
    }
}
