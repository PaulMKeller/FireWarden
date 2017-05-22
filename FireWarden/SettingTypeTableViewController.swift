//
//  SettingTypeTableViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 2/5/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class SettingTypeTableViewController: UITableViewController {
    
    var locationsArray = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //getLocationData()
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
        print(self.locationsArray.count)
        return self.locationsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTypeCell", for: indexPath)

        // Configure the cell...
        let currentLocation = self.locationsArray[indexPath.row]
        
        cell.textLabel?.text = currentLocation.locationName + " - " + currentLocation.floor
        cell.detailTextLabel?.text = currentLocation.country
        
        return cell
    }
    
    /*
    func getLocationData() {
        //self.activityIndicator.startAnimating()
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
                if let content=data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        print(myJson)
                        if myJson.count > 0
                        {
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let locationDetails = Location(locationID: obj["LocationID"] as! Int32, locationName: obj["LocationName"] as! String, floor: obj["Floor"] as! String, countryID: obj["CountryID"] as! Int32, country: obj["Country"] as! String)
                                print(locationDetails)
                                self.locationsArray.append(locationDetails)
                            }
                            
                            /*
                            // DON'T KNOW WHY I CAN'T GET THIS TO FUCKING WORK!
                            var locationJson = myJson[0] as! NSDictionary
                            var locationDetails = Location(locationID: locationJson["LocationID"] as! Int32, locationName: locationJson["LocationName"] as! String, floor: locationJson["Floor"] as! String, countryID: locationJson["CountryID"] as! Int32, country: locationJson["Country"] as! String)
                            self.locationsArray.append(locationDetails)
                            
                            locationJson = myJson[1] as! NSDictionary
                            locationDetails = Location(locationID: locationJson["LocationID"] as! Int32, locationName: locationJson["LocationName"] as! String, floor: locationJson["Floor"] as! String, countryID: locationJson["CountryID"] as! Int32, country: locationJson["Country"] as! String)
                            self.locationsArray.append(locationDetails)
                            
                            locationJson = myJson[2] as! NSDictionary
                            locationDetails = Location(locationID: locationJson["LocationID"] as! Int32, locationName: locationJson["LocationName"] as! String, floor: locationJson["Floor"] as! String, countryID: locationJson["CountryID"] as! Int32, country: locationJson["Country"] as! String)
                            self.locationsArray.append(locationDetails)
                            */
                            
                            /*
                            
                            NEED TO LOOP THROUGH THE LOCATIONS AND SETUP THE ARRAY
                             
                            let locationDetails = Location(locationID: locationArray["LocationID"] as! Int32, locationName: locationArray["Location"] as! String, floor: locationArray["Floor"] as! String, countryID: locationArray["CountryID"] as! Int32, country: locationArray["Country"] as! String)
                            
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Login Name or Password failure."
                                print("Successful Location Retrieval")
                            })
                            */
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
 
    */

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
