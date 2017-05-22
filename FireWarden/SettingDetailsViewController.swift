//
//  SettingDetailsViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 2/5/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class SettingDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
    }
    @IBOutlet var locationNameText: UITextField!
    @IBOutlet var floorText: UITextField!
    @IBOutlet var countryPicker: UIPickerView!
    var currentLocation = Location()
    var countryList = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        
        let countrySing = Country(CountryID: 1, Country: "Singapore")
        let countryPhil = Country(CountryID: 2, Country: "Phillipines")
        countryList.append(countrySing)
        countryList.append(countryPhil)
        
        loadLocationData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLocationData() {
        /*
         self.locationID = 0
         self.locationName = ""
         self.floor = ""
         self.countryID = 0
         self.country = ""
 */
        locationNameText.text = currentLocation.locationName
        floorText.text = currentLocation.floor
        
        //Now do the Country Picker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currentCountry:Country = countryList[row]
        return currentCountry.country
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
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
