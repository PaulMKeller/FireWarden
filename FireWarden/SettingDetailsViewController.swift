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
        saveData()
    }
    @IBOutlet var locationNameText: UITextField!
    @IBOutlet var floorText: UITextField!
    @IBOutlet var countryPicker: UIPickerView!
    var currentLocation = Location()
    var countryList = [Country]()
    var isExistingRecord = true
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        
        loadLocationData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLocationData() {
        locationNameText.text = currentLocation.locationName
        floorText.text = currentLocation.floor

        var i:Int
        
        i = 0
        for obj in countryList {
            if obj.country == currentLocation.country {
                self.countryPicker.selectRow(i, inComponent: 0, animated: true)
                break
            }
            i += 1
        }
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
    
    func saveData() {
        if isExistingRecord {
            saveExistingData()
        }
        else
        {
            saveNewRecord()
        }
    }
    
    func saveExistingData() {
        // NEED TO CODE THIS ON MONDAY
    }
    
    func saveNewRecord() {
        // NEED TO CODE THIS ON MONDAY
    }
    
    func prepareForLocationDetailSegue() {
        let url = URL(string: "http://www.gratuityp.com/pk/GetData.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "ScriptName=sp_Location_Update"
        postString += "&ParamString="
        postString += "'LocationID=" + String(currentLocation.locationID) + "'"
        postString += "&LocationName=" + currentLocation.locationName + "'"
        postString += "&Floor=" + currentLocation.floor + "'"
        postString += "&CountryID=" + String(currentLocation.countryID) + "'"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                if data != nil
                {
                    do
                    {
                        DispatchQueue.main.async(execute: {
                        print("Successful Location Retrieval")
                        })
                        
                    }
                    catch
                    {
                        print(error)
                        DispatchQueue.main.async(execute: {
                            print("Un-Successful Location Retrieval")
                        })
                    }
                }
            }
        }
        
        task.resume()
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
