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
        saveData()
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
            if obj.locationID==currentPerson.personLocation.locationID{
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
        return currentLocation.country + " - " + currentLocation.locationName + " (" + currentLocation.floor + ")"
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
        currentPerson.personLocation = currentLocation
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = locationsArray[row].country + " - " + locationsArray[row].locationName + " (" + locationsArray[row].floor + ")"
        pickerLabel.font = UIFont(name: "Arial", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
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
        
        currentPerson.firstName = firstNameText.text!
        currentPerson.lastName = lastNameText.text!
        currentPerson.gender = genderText.text!
        //location changes handled by the picker view change event
        
        let url = URL(string: "http://www.gratuityp.com/pk/PersonUpdate.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "PersonID=" + String(currentPerson.personID)
        postString += "&FirstName=" + currentPerson.firstName
        postString += "&LastName=" + currentPerson.lastName
        postString += "&Gender=" + currentPerson.gender
        postString += "&LocationID=" + String(currentLocation.locationID)
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
                            self.delegate?.passPersonDataBack(isNewRecord: false, arrayIndex: self.existingArrayIndex, objectToPass: self.currentPerson)
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
        currentPerson.firstName = firstNameText.text!
        currentPerson.lastName = lastNameText.text!
        currentPerson.gender = genderText.text!
        //location changes handled by the picker view change event
        
        let url = URL(string: "http://www.gratuityp.com/pk/PersonInsert.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "&FirstName=" + currentPerson.firstName
        postString += "&LastName=" + currentPerson.lastName
        postString += "&Gender=" + currentPerson.gender
        postString += "&LocationID=" + String(currentLocation.locationID)
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
                            
                            self.currentLocation = newLocation
                            self.currentPerson.personID = Int32(newRecordArray["PersonID"] as! String)!
                            self.currentPerson.personLocation = newLocation
                            
                            DispatchQueue.main.async(execute: {
                                //self.performSegue(withIdentifier: "loginSegue", sender: self)
                                self.newRecordAdded = true
                                self.delegate?.passPersonDataBack(isNewRecord: true, arrayIndex: self.existingArrayIndex, objectToPass: self.currentPerson)
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
