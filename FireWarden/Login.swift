//
//  Login.swift
//  FireWarden
//
//  Created by Paul Keller on 12/5/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Login {
    var loginName: String
    var password: String
    var adminRole: String
    
    init(loginName: String, password: String, adminRole: String) {
        self.loginName = loginName
        self.password = password
        self.adminRole = adminRole
    }
}
