//
//  SettingTypeObj.swift
//  FireWarden
//
//  Created by Paul Keller on 27/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class SettingTypeObj {

    var settingID: Int32 = 0
    var settingType: String = ""
    var settingKey: String = ""
    var settingValue: String = ""
    
    init() {
        self.settingID = 0
        self.settingType = ""
        self.settingKey = ""
        self.settingValue = ""
    }
    
    init(settingID: Int32, settingType: String, settingKey: String, settingValue: String) {
        self.settingID = settingID
        self.settingType = settingType
        self.settingKey = settingKey
        self.settingValue = settingValue
    }
}
