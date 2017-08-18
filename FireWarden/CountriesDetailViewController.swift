//
//  CountriesDetailViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 13/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class CountriesDetailViewController: UIViewController {
    
    
    @IBOutlet weak var countryNameText: UITextField!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        currentCountry.country = countryNameText.text!
        saveData()
    }
    
    var currentCountry = Country()
    var existingArrayIndex: Int32 = 0
    var isExistingRecord: Bool = false
    var newRecordAdded: Bool = false
    weak var delegate: CountryPassBackDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isExistingRecord {
            countryNameText.text = currentCountry.country
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let url = URL(string: "http://www.gratuityp.com/pk/CountryUpdate.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "CountryID=" + String(currentCountry.countryID)
        postString += "&CountryName=" + currentCountry.country
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
                            self.delegate?.passCountryDataBack(isNewRecord: false, arrayIndex: self.existingArrayIndex, objectToPass: self.currentCountry)
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func saveNewRecord() {
        let url = URL(string: "http://www.gratuityp.com/pk/CountryInsert.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "CountryName=" + currentCountry.country
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
                            let newCountry = Country()
                            newCountry.countryID = Int32(newRecordArray["CountryID"] as! String)!
                            newCountry.country = newRecordArray["Country"] as! String
                            
                            self.currentCountry = newCountry
                            
                            DispatchQueue.main.async(execute: {
                                //self.performSegue(withIdentifier: "loginSegue", sender: self)
                                self.newRecordAdded = true
                                self.delegate?.passCountryDataBack(isNewRecord: true, arrayIndex: self.existingArrayIndex, objectToPass: self.currentCountry)
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
