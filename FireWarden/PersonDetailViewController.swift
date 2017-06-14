//
//  PersonDetailViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 14/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    var locationsArray = [Location]()
    var currentPerson = Person()
    var currentLocation = Location()
    var isExistingRecord = true
    var newRecordAdded = false
    var existingArrayIndex: Int32! = 0
    
    weak var delegate: PersonPassBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        loadPersonData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPersonData() {
        firstNameText.text = currentPerson.firstName
        lastNameText.text = currentPerson.lastName
        genderText.text = currentPerson.gender
        
        var i:Int
        
        i = 0
        for obj in locationsArray {
            if obj.locationName == currentPerson.personLocation.locationName {
                self.locationPicker.selectRow(i, inComponent: 0, animated: true)
                break
            }
            i += 1
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currentLocation:Location = locationsArray[row]
        return currentLocation.country + " - " + currentLocation.locationName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        let newLocation:Location = locationsArray[row]
        currentLocation.locationID = newLocation.locationID
        currentLocation.locationName = newLocation.locationName
        currentLocation.floor = newLocation.floor
        currentLocation.countryID = newLocation.countryID
        currentLocation.country = newLocation.country
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
