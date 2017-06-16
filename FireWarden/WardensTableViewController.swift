//
//  WardensTableViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 19/5/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class WardensTableViewController: UITableViewController, WardenPassBackDelegate {

    @IBAction func addTapped(_ sender: Any) {
        prepareForWardenDetailSegue(segueIdentifier: "addWardenSegue")
    }
    
    var wardenArray = [Warden]()
    var currentWarden = Warden()
    var locationsArray = [Location]()
    var peopleArray = [Person]()
    var selectedRowIndex: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return self.wardenArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wardenIdentifier", for: indexPath)

        let currentWarden = self.wardenArray[indexPath.row]
        
        cell.textLabel?.text = currentWarden.wardenPerson.firstName + " " + currentWarden.wardenPerson.lastName
        cell.detailTextLabel?.text = currentWarden.wardenLocation.country + " - " + currentWarden.wardenLocation.locationName + " (" + currentWarden.wardenLocation.floor + ")"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentWarden = wardenArray[indexPath.row]
        self.selectedRowIndex = Int32(indexPath.row)
        prepareForWardenDetailSegue(segueIdentifier: "wardenDetailSegue")
    }
    
    func prepareForWardenDetailSegue(segueIdentifier: String) {
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
                                self.getPersonData(segueIdentifier: segueIdentifier)
                                
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
    
    func getPersonData(segueIdentifier: String) {
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
                        if myJson.count > 0
                        {
                            self.peopleArray.removeAll()
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let locationDetails = Location(locationID: obj["LocationID"] as! Int32, locationName: obj["LocationName"] as! String, floor: obj["Floor"] as! String, countryID: obj["CountryID"] as! Int32, country: obj["CountryName"] as! String)
                                
                                let personDetails = Person(personID: obj["PersonID"] as! Int32, firstName: obj["FirstName"] as! String, lastName: obj["LastNight"] as! String, gender: obj["Gender"] as! String, personLocation: locationDetails)
                                
                                self.peopleArray.append(personDetails)
                            }
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Successful Warden Retrieval")
                                
                                //Pass the locations array to the next view
                                self.performSegue(withIdentifier: segueIdentifier, sender: self)
                                
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Un-Successful Warden Retrieval")
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
        let nextScene = segue.destination as! WardenDetailViewController
        nextScene.personArray = self.peopleArray
        nextScene.locationArray = self.locationsArray
        nextScene.delegate = self
        if segue.identifier == "personDetailSegue" {
            nextScene.currentWarden = self.currentWarden
            nextScene.existingArrayIndex = self.selectedRowIndex
        } else if segue.identifier == "addPersonSegue" {
            nextScene.currentWarden = Warden()
            nextScene.isExistingRecord = false
            nextScene.existingArrayIndex = 0
        }
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
    
    func passWardenDataBack(isNewRecord: Bool, arrayIndex: Int32, objectToPass: Warden) {
        // Add a UITableViewCell to the table and add the new location to the locations array
        if isNewRecord {
            //do new record addition of cell
            wardenArray.append(objectToPass)
            tableView.reloadData()
        } else {
            // Update the existing cell and the array
            wardenArray.remove(at: Int(arrayIndex))
            wardenArray.insert(objectToPass, at: Int(arrayIndex))
            tableView.reloadData()
        }
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
