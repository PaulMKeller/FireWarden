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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        settingsList.append("Locations")
        settingsList.append("People")
        settingsList.append("Wardens")
        settingsList.append("General")
        settingsList.append("Logins")
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
            //call locations code
            prepareForLocationSegue()
        case 1:
            //call People code
            prepareForPeopleSegue()
        case 2:
            //call Wardens
            prepareForWardensSegue()
        case 3:
            //call General
            prepareForGeneralSegue()
        case 4:
            //call Logins
            prepareForLoginsSegue()
        default:
            // Return an error...
            break
        }
    }
    
    func prepareForLocationSegue() {
        let waitingView = showWaitingView()
        
        var locationsArray = [Location]()
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
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let locationDetails = Location(locationID: obj["LocationID"] as! Int32, locationName: obj["LocationName"] as! String, floor: obj["Floor"] as! String, countryID: obj["CountryID"] as! Int32, country: obj["Country"] as! String)
                                print(locationDetails)
                                locationsArray.append(locationDetails)
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
    }
    
    func prepareForPeopleSegue() {
        
    }
    
    func prepareForWardensSegue() {
        
    }
    
    func prepareForGeneralSegue() {
        
    }
    
    func prepareForLoginsSegue() {
        
    }

private func showWaitingView() -> UIView {
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    effectView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(effectView)
    NSLayoutConstraint.activate([
        effectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        effectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        effectView.topAnchor.constraint(equalTo: view.topAnchor),
        effectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    effectView.addSubview(spinner)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
