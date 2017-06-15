//
//  WardenPassBack.swift
//  FireWarden
//
//  Created by Paul Keller on 15/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
protocol WardenPassBackDelegate: class {
    func passWardenDataBack(isNewRecord: Bool, arrayIndex: Int32, objectToPass: Warden)
}
