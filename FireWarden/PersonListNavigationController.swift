//
//  PersonListNavigationController.swift
//  FireWarden
//
//  Created by Paul Keller on 27/4/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class PersonListNavigationController: UINavigationController {
    
    var wardenList = [WardenCount]()
    var personList = [PersonListObj]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //prepareForNavigationSegue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
