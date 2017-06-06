//
//  PassDataBack.swift
//  FireWarden
//
//  Created by Paul Keller on 2/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
protocol DataBackDelegate: class {
    func passLocationDataBack(isNewRecord: Bool, arrayIndex: Int32, objectToPass: Location)
}
