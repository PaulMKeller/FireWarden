//
//  PersonPassBack.swift
//  FireWarden
//
//  Created by Paul Keller on 14/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
protocol PersonPassBackDelegate: class {
    func passPersonDataBack(isNewRecord: Bool, arrayIndex: Int32, objectToPass: Person)
}
