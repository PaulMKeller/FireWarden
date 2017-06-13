//
//  CountryPassBack.swift
//  FireWarden
//
//  Created by Paul Keller on 13/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation
protocol CountryPassBackDelegate: class {
    func passCountryDataBack(isNewRecord: Bool, arrayIndex: Int32, objectToPass: Country)
}
