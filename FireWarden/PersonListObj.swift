//
//  PersonListObj.swift
//  FireWarden
//
//  Created by Paul Keller on 12/7/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class PersonListObj {
    
    var wardenObj = Warden()
    var personObj = [Person]()
    
    init() {
        self.wardenObj = Warden()
        self.personObj = [Person]()
        
    }
    
}
