//
//  WardenDetailViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 15/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class WardenDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var wardenPicker: UIPickerView!
    @IBOutlet weak var wardenLocation: UIPickerView!
    @IBAction func saveTapped(_ sender: Any) {
        saveData()
    }
    
    var currentWarden = Warden()
    var currentWardenPerson = Person()
    var currentWardenLocation = Location()
    var personArray = [Person]()
    var locationArray = [Location]()
    var existingArrayIndex: Int32 = 0
    var isExistingRecord: Bool = true
    var newRecordAdded: Bool = false
    
    weak var delegate: WardenPassBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.wardenPicker.delegate = self
        self.wardenPicker.dataSource = self
        
        self.wardenLocation.delegate = self
        self.wardenLocation.dataSource = self
        
        print("WardenID = " + String(currentWarden.wardenID))
        print("PersonID = " + String(currentWardenPerson.personID))
        print("LocationID = " + String(currentWardenLocation.locationID))
        currentWardenPerson = currentWarden.wardenPerson
        currentWardenLocation = currentWarden.wardenLocation
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        
        if isExistingRecord==true {
            var i:Int

            i = 0
            for obj in personArray {
                if obj.personID==currentWardenPerson.personID {
                    self.wardenPicker.selectRow(i, inComponent: 0, animated: true)
                    self.wardenPicker.isUserInteractionEnabled = false
                    break
                }
                i += 1
            }
            
            i = 0
            for obj in locationArray {
                if obj.locationID==currentWardenLocation.locationID {
                    self.wardenLocation.selectRow(i, inComponent: 0, animated: true)
                    break
                }
                i += 1
            }
        }
        else
        {
            //self.wardenPicker.selectRow(1, inComponent: 0, animated: true)
            //self.wardenLocation.selectRow(1, inComponent: 0, animated: true)
            currentWardenPerson = personArray[0]
            currentWarden.wardenPerson = currentWardenPerson
            
            currentWardenLocation = locationArray[0]
            currentWarden.wardenLocation = currentWardenLocation
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.restorationIdentifier == "wardenPersonPicker" {
            return 1
        }
        else
        {
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.restorationIdentifier == "wardenPersonPicker" {
            return personArray.count
        }
        else
        {
            return locationArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.restorationIdentifier == "wardenPersonPicker" {
            let currentPerson:Person = personArray[row]
            return currentPerson.firstName + " " + currentPerson.lastName
        }
        else
        {
            let currentLocation:Location = locationArray[row]
            return currentLocation.country + " - " + currentLocation.locationName + " (" + currentLocation.floor + ")"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        if pickerView.restorationIdentifier == "wardenPersonPicker" {
            let newPerson:Person = personArray[row]
            currentWardenPerson = newPerson
            currentWarden.wardenPerson = currentWardenPerson
        }
        else
        {
            let newLocation:Location = locationArray[row]
            currentWardenLocation = newLocation
            currentWarden.wardenLocation = currentWardenLocation
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        if pickerView.restorationIdentifier == "wardenPersonPicker" {
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.black
            pickerLabel.text = personArray[row].firstName + " " + personArray[row].lastName
            pickerLabel.font = UIFont(name: "Arial", size: 15) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
        else
        {
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.black
            pickerLabel.text = locationArray[row].country + " - " + locationArray[row].locationName + " (" + locationArray[row].floor + ")"
            pickerLabel.font = UIFont(name: "Arial", size: 15) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
        
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
        
        //changes handled by the picker view change event
        
        let url = URL(string: "http://www.gratuityp.com/pk/WardenUpdate.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "WardenID=" + String(currentWarden.wardenID)
        postString += "&LocationID=" + String(currentWardenLocation.locationID)
        postString += "&PersonID=" + String(currentWardenPerson.personID)
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
                        let myJson = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers, JSONSerialization.ReadingOptions.allowFragments]) as AnyObject
                        print(myJson)
                        DispatchQueue.main.async(execute: {
                            print("Successful Person Update")
                            self.delegate?.passWardenDataBack(isNewRecord: false, arrayIndex: self.existingArrayIndex, objectToPass: self.currentWarden)
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
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
    
    func saveNewRecord() {
        //Changes handled by the picker view change event
        
        let url = URL(string: "http://www.gratuityp.com/pk/WardenInsert.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "&PersonID=" + String(currentWardenPerson.personID)
        postString += "&LocationID=" + String(currentWardenLocation.locationID)
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
                        let myJson = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers, JSONSerialization.ReadingOptions.allowFragments]) as AnyObject
                        print(myJson)
                        if myJson.count > 0
                        {
                            let newRecordArray = myJson[0] as! NSDictionary
                            let newLocation = Location()
                            newLocation.locationID = newRecordArray["LocationID"] as! Int32
                            newLocation.locationName = newRecordArray["LocationName"] as! String
                            newLocation.floor = newRecordArray["Floor"] as! String
                            newLocation.countryID = newRecordArray["CountryID"] as! Int32
                            newLocation.country = newRecordArray["CountryName"] as! String
                            
                            self.currentWardenLocation = newLocation
                            
                            let newPersonLocation = Location()
                            newPersonLocation.locationID = newRecordArray["PersonLocationID"] as! Int32
                            newPersonLocation.locationName = newRecordArray["PersonLocationName"] as! String
                            newPersonLocation.floor = newRecordArray["PersonFloor"] as! String
                            newPersonLocation.countryID = newRecordArray["PersonCountryID"] as! Int32
                            newPersonLocation.country = newRecordArray["PersonCountryName"] as! String
                            
                            let newPerson = Person()
                            newPerson.personID = newRecordArray["PersonID"] as! Int32
                            newPerson.firstName = newRecordArray["FirstName"] as! String
                            newPerson.lastName = newRecordArray["LastName"] as! String
                            newPerson.gender = newRecordArray["Gender"] as! String
                            newPerson.personLocation = newPersonLocation
                            
                            self.currentWardenPerson = newPerson
                            
                            self.currentWarden.wardenID = newRecordArray["WardenID"] as! Int32
                            self.currentWarden.wardenPerson = self.currentWardenPerson
                            self.currentWarden.wardenLocation = self.currentWardenLocation
                            
                            DispatchQueue.main.async(execute: {
                                //self.performSegue(withIdentifier: "loginSegue", sender: self)
                                self.newRecordAdded = true
                                self.delegate?.passWardenDataBack(isNewRecord: true, arrayIndex: self.existingArrayIndex, objectToPass: self.currentWarden)
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
