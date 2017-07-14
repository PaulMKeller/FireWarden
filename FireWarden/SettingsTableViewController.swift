//
//  SettingsTableViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 2/5/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var settingsList = [String]()
    var locationsArray = [Location]()
    var countriesArray = [Country]()
    var peopleArray = [Person]()
    var wardenArray = [Warden]()
    var settingTypesArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        settingsList.append("Countries")
        settingsList.append("Locations")
        settingsList.append("People")
        settingsList.append("Wardens")
        settingsList.append("General")
        //settingsList.append("Logins")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsList[indexPath.row].lowercased() + "Cell", for: indexPath)

        // Configure the cell...
        // cell.textLabel?.text = settingsList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //call countries code
            prepareForCountriesSegue()
        case 1:
            //call locations code
            prepareForLocationSegue(tableView: tableView)
        case 2:
            //call People code
            prepareForPeopleSegue()
        case 3:
            //call Wardens
            prepareForWardensSegue()
        case 4:
            //call General
            prepareForGeneralSegue()
        case 5:
            //call Logins
            prepareForLoginsSegue()
        default:
            // Return an error...
            break
        }
    }
    
    func prepareForLocationSegue(tableView: UITableView) {
        let waitingView = showWaitingView(tableView: tableView)
        
        let url = URL(string: "http://www.gratuityp.com/pk/GetData.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "ScriptName=sp_Location_GetList&ParamString=''"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                defer {
                    DispatchQueue.main.async {
                        waitingView.removeFromSuperview()
                    }
                }
                if let content=data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        print(myJson)
                        if myJson.count > 0
                        {
                            self.locationsArray.removeAll()
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let locationDetails = Location(locationID: obj["LocationID"] as! Int32, locationName: obj["LocationName"] as! String, floor: obj["Floor"] as! String, countryID: obj["CountryID"] as! Int32, country: obj["Country"] as! String)
                                print(locationDetails)
                                self.locationsArray.append(locationDetails)
                            }
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Successful Location Retrieval")
                                
                                //Pass the locations array to the next view
                                self.performSegue(withIdentifier: "locationsSegue", sender: self)
                                
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Un-Successful Location Retrieval")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationsSegue" {
            let nextScene = segue.destination as! SettingTypeTableViewController
            nextScene.locationsArray = self.locationsArray
        } else if segue.identifier == "peopleSegue" {
            let nextScene = segue.destination as! PeopleTableViewController
            nextScene.peopleArray = self.peopleArray
        } else if segue.identifier == "wardensSegue" {
            let nextScene = segue.destination as! WardensTableViewController
            nextScene.wardenArray = self.wardenArray
        } else if segue.identifier == "generalSettingsSegue" {
            let nextScene = segue.destination as! GeneralTableViewController
            nextScene.settingsData = self.settingTypesArray
        } else if segue.identifier == "loginsSegue" {
            _ = segue.destination as! LoginsViewController
        } else if segue.identifier == "countriesSegue" {
            let nextScene = segue.destination as! CountriesTableViewController
            nextScene.countriesArray = self.countriesArray
        }
    }
    
    func prepareForPeopleSegue() {
        let waitingView = showWaitingView(tableView: tableView)
        
        let url = URL(string: "http://www.gratuityp.com/pk/GetData.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "ScriptName=sp_Person_GetList&ParamString=''"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                defer {
                    DispatchQueue.main.async {
                        waitingView.removeFromSuperview()
                    }
                }
                if let content=data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        print(myJson)
                        //If there's no records in the table, this will fail...
                        if myJson.count > 0
                        {
                            self.peopleArray.removeAll()
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let locationDetails = Location(locationID: obj["LocationID"] as! Int32, locationName: obj["LocationName"] as! String, floor: obj["Floor"] as! String, countryID: obj["CountryID"] as! Int32, country: obj["Country"] as! String)
                                let personDetails = Person(personID: obj["PersonID"] as! Int32, firstName: obj["FirstName"] as! String, lastName: obj["LastName"] as! String, gender: obj["Gender"] as! String, personLocation: locationDetails)
                                print(locationDetails)
                                self.peopleArray.append(personDetails)
                            }
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Successful People Retrieval")
                                
                                //Pass the locations array to the next view
                                self.performSegue(withIdentifier: "peopleSegue", sender: self)
                                
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Un-Successful People Retrieval")
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
    
    func prepareForWardensSegue() {
        let waitingView = showWaitingView(tableView: tableView)
        
        let url = URL(string: "http://www.gratuityp.com/pk/GetData.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "ScriptName=sp_Warden_GetList&ParamString=''"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                defer {
                    DispatchQueue.main.async {
                        waitingView.removeFromSuperview()
                    }
                }
                if let content=data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        print(myJson)
                        //If there's no records in the table, this will fail...
                        if myJson.count > 0
                        {
                            self.wardenArray.removeAll()
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let locationDetails = Location(locationID: obj["LocationID"] as! Int32, locationName: obj["LocationName"] as! String, floor: obj["Floor"] as! String, countryID: obj["CountryID"] as! Int32, country: obj["Country"] as! String)
                                let personDetails = Person(personID: obj["PersonID"] as! Int32, firstName: obj["FirstName"] as! String, lastName: obj["LastName"] as! String, gender: obj["Gender"] as! String, personLocation: locationDetails)
                                
                                let wardenDetails = Warden(wardenID: obj["WardenID"] as! Int32, wardenPerson: personDetails, wardenLocation: locationDetails)
                                
                                self.wardenArray.append(wardenDetails)
                            }
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Successful People Retrieval")
                                
                                //Pass the locations array to the next view
                                self.performSegue(withIdentifier: "wardensSegue", sender: self)
                                
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Un-Successful People Retrieval")
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
    
    func prepareForGeneralSegue() {
        let waitingView = showWaitingView(tableView: tableView)
        
        let url = URL(string: "http://www.gratuityp.com/pk/GetData.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "ScriptName=sp_SettingsType_GetList&ParamString=''"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                defer {
                    DispatchQueue.main.async {
                        waitingView.removeFromSuperview()
                    }
                }
                if let content=data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        print(myJson)
                        if myJson.count > 0
                        {
                            self.settingTypesArray.removeAll()
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let settingType = obj["SettingType"] as! String
                                print(settingType)
                                self.settingTypesArray.append(settingType)
                            }
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Successful Setting Type Retrieval")
                                
                                //Pass the locations array to the next view
                                self.performSegue(withIdentifier: "generalSettingsSegue", sender: self)
                                
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Un-Successful Location Retrieval")
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
    
    func prepareForLoginsSegue() {
        self.performSegue(withIdentifier: "loginsSegue", sender: self)
    }
    
    func prepareForCountriesSegue() {
        let waitingView = showWaitingView(tableView: tableView)
        
        let url = URL(string: "http://www.gratuityp.com/pk/GetData.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "ScriptName=sp_Country_GetList&ParamString=''"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                defer {
                    DispatchQueue.main.async {
                        waitingView.removeFromSuperview()
                    }
                }
                if let content=data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        print(myJson)
                        if myJson.count > 0
                        {
                            self.countriesArray.removeAll()
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let countryDetails = Country(CountryID: obj["CountryID"] as! Int32, Country: obj["Country"] as! String)
                                print(countryDetails)
                                self.countriesArray.append(countryDetails)
                            }
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Successful Location Retrieval")
                                
                                //Pass the locations array to the next view
                                self.performSegue(withIdentifier: "countriesSegue", sender: self)
                                
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Un-Successful Location Retrieval")
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

private func showWaitingView(tableView: UITableView) -> UIView {
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    effectView.translatesAutoresizingMaskIntoConstraints = false
    tableView.addSubview(effectView)
    NSLayoutConstraint.activate([
        effectView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
        effectView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        effectView.topAnchor.constraint(equalTo: tableView.topAnchor),
        effectView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    effectView.addSubview(spinner)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    
    spinner.startAnimating()
    return effectView
}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
