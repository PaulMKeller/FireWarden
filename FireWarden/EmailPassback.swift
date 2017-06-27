//
//  EmailPassback.swift
//  FireWarden
//
//  Created by Paul Keller on 27/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
protocol SettingPassBackDelegate: class {
    func passSettingDataBack(isNewRecord: Bool, arrayIndex: Int32, objectToPass: SettingTypeObj)
}
