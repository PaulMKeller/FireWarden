//
//  EmailDetailListViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 21/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class EmailDetailListViewController: UIViewController {

    var currentEmail = SettingTypeObj()
    var selectedRowIndex: Int32! = 0
    var isExistingRecord: Bool = true
    var existingArrayIndex: Int32 = 0
    weak var delegate: SettingPassBackDelegate?
    
    @IBOutlet weak var emailAddressText: UITextField!
    
    @IBAction func saveTapped(_ sender: Any) {
        currentEmail.settingValue = emailAddressText.text!
        saveData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isExistingRecord {
            emailAddressText.text = currentEmail.settingValue
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
        let url = URL(string: "http://www.gratuityp.com/pk/SettingsDataChange.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        var postString = "SettingID=" + String(currentEmail.settingID)
        postString += "&SettingType=" + currentEmail.settingType
        postString += "&SettingKey=" + currentEmail.settingKey
        postString += "&SettingValue=" + currentEmail.settingValue
        postString += "&SPType=Update"
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
                            print("Successful Email Update")
                            self.delegate?.passSettingDataBack(isNewRecord: false, arrayIndex: self.existingArrayIndex, objectToPass: self.currentEmail)
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func saveNewRecord() {
        let url = URL(string: "http://www.gratuityp.com/pk/SettingsDataChange.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "SettingType=" + currentEmail.settingType
        postString += "&SettingKey=" + currentEmail.settingKey
        postString += "&SettingValue=" + currentEmail.settingValue
        postString += "&SPType=Insert"
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
                            let newEmail = SettingTypeObj()
                            newEmail.settingID = Int32(newRecordArray["SettingID"] as! String)!
                            newEmail.settingType = newRecordArray["SettingType"] as! String
                            newEmail.settingKey = newRecordArray["SettingKey"] as! String
                            newEmail.settingValue = newRecordArray["SettingValue"] as! String
                            
                            self.currentEmail = newEmail
                            
                            DispatchQueue.main.async(execute: {
                                self.delegate?.passSettingDataBack(isNewRecord: true, arrayIndex: self.existingArrayIndex, objectToPass: self.currentEmail)
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
