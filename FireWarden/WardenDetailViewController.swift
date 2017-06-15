//
//  WardenDetailViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 15/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class WardenDetailViewController: UIViewController {
    
    @IBOutlet weak var wardenPicker: UIPickerView!
    @IBOutlet weak var wardenLocation: UIPickerView!
    @IBAction func saveTapped(_ sender: Any) {
        
    }
    
    var currentWarden = Warden()
    var currentWardenPerson = Person()
    var currentWardenLocation = Location()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
