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
    var newRecordAdded = false
    var existingArrayIndex: Int32! = 0
    
    weak var delegate: DataBackDelegate?
    
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
        let newCountry:Country = countryList[row]
        currentLocation.countryID = newCountry.countryID
        currentLocation.country = newCountry.country
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
        
        currentLocation.locationName = locationNameText.text!
        currentLocation.floor = floorText.text!
        //country changes handled by the picker view change event
        
        let url = URL(string: "http://www.gratuityp.com/pk/LocationChanges.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "LocationID=" + String(currentLocation.locationID)
        postString += "&LocationName=" + currentLocation.locationName
        postString += "&Floor=" + currentLocation.floor
        postString += "&CountryID=" + String(currentLocation.countryID)
        postString = postString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(postString)
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
                            self.delegate?.passLocationDataBack(isNewRecord: false, arrayIndex: self.existingArrayIndex, objectToPass: self.currentLocation)
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func saveNewRecord() {
        currentLocation.locationName = locationNameText.text!
        currentLocation.floor = floorText.text!
        //country changes handled by the picker view change event
        
        let url = URL(string: "http://www.gratuityp.com/pk/LocationInsert.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "LocationName=" + currentLocation.locationName
        postString += "&Floor=" + currentLocation.floor
        postString += "&CountryID=" + String(currentLocation.countryID)
        postString = postString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(postString)
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
                        let myJson = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers, JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                        print(myJson)
                        if myJson.count > 0
                        {
                            let newRecordArray = myJson[0] as! NSDictionary
                            let newLocation = Location()
                            newLocation.locationID = Int32(newRecordArray["LocationID"] as! String)!
                            newLocation.locationName = newRecordArray["LocationName"] as! String
                            newLocation.floor = newRecordArray["Floor"] as! String
                            newLocation.countryID = newRecordArray["CountryID"] as! Int32
                            newLocation.country = newRecordArray["CountryName"] as! String
                            
                            self.currentLocation = newLocation
                            
                            DispatchQueue.main.async(execute: {
                                //self.performSegue(withIdentifier: "loginSegue", sender: self)
                                self.newRecordAdded = true
                                self.delegate?.passLocationDataBack(isNewRecord: true, arrayIndex: self.existingArrayIndex, objectToPass: self.currentLocation)
                                //perform segue back so you can only add one record
                                _ = self.navigationController?.popViewController(animated: true)
                                print("Successful Insert")
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                print("Unsuccessful Insert")
                            })
                        }
                        
                    }
                    catch
                    {
                        print(error)
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
