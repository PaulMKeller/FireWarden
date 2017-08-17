//
//  PersonListTableViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 27/4/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class PersonListTableViewController: UITableViewController {
    
    var wardenList = [WardenCount]()
    var personList = [PersonListObj]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        loadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if wardenList.count == 0 {
            return 1
        } else {
            return wardenList.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if wardenList.count == 0 {
            return 1
        } else {
            var sectionWarden = WardenCount()
            sectionWarden = wardenList[section]
            return Int(sectionWarden.personCount)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)

        // Configure the cell...
        // Filter the PersonList by IndexPath.Section
        // and set the rows.
        
        if wardenList.count > 0 {
            let currentPersonList = personList[indexPath.section]
            let currentPerson = currentPersonList.personObj[indexPath.row]
            
            cell.textLabel?.text = "\(currentPerson.firstName) \(currentPerson.lastName)"
            cell.detailTextLabel?.text = "\(currentPerson.personLocation.locationName), \(currentPerson.personLocation.floor), \(currentPerson.personLocation.country)"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if wardenList.count > 0 {
            let currentWarden = personList[section].wardenObj
            return "Warden: \(currentWarden.firstName) \(currentWarden.lastName)"
        } else {
            return "Loading Data"
        }
    }
 
    func loadData() {
        //let waitingView = showWaitingView(tableView: tableView)
        
        let url = URL(string: "http://www.gratuityp.com/pk/GetData.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "ScriptName=sp_PersonList_GetList&ParamString=''"
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
                        //waitingView.removeFromSuperview()
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
                            self.wardenList.removeAll()
                            for item in myJson {
                                let obj = item as! NSDictionary
                                
                                if obj.count <= 5 {
                                    //It's a WardenCount obj
                                    let wardenCountObj = WardenCount(wardenID: obj["WardenID"] as! Int32, firstName: obj["FirstName"] as! String, lastName: obj["LastName"] as! String, personCount: obj["PersonCount"] as! Int32, sectionNumber: Int32(obj["SectionNumber"] as! String)!)
                                    print(wardenCountObj)
                                    self.wardenList.append(wardenCountObj)
                                    
                                    let wardenPersonList = [Person]()
                                    let listObj = PersonListObj()
                                    listObj.wardenObj = wardenCountObj
                                    listObj.personObj = wardenPersonList
                                    
                                    self.personList.append(listObj)
                                    
                                    //This creates an array of wardens with a blank personObj array
                                    //the else part should then find the correct warden and append the personObj to that array
                                }
                                else
                                {
                                    //it's a PersonListObj
                                    
                                    let locationObj = Location(locationID: obj["PersonLocationID"] as! Int32, locationName: obj["LocationName"] as! String, floor: obj["Floor"] as! String, countryID: obj["PersonCountryID"] as! Int32, country: obj["Country"] as! String)
                                    
                                    let personObj = Person(personID: obj["PersonPersonID"] as! Int32, firstName: obj["FirstName"] as! String, lastName: obj["LastName"] as! String, gender: obj["Gender"] as! String, personLocation: locationObj)
                                    
                                    // Now you need to locate the correct row in WardenList and append the PersonObj
                                    // to it's person array
                                    //personList.index(where: <#T##(PersonListObj) throws -> Bool#>) Something like this...
                                    if let i = self.personList.index(where: { $0.wardenObj.wardenID == obj["WardenID"] as! Int32 }) {
                                        //self.personList.insert(personObj, at: i)
                                        let currentPersonListObj = self.personList[i]
                                        currentPersonListObj.personObj.append(personObj)
                                        
                                        self.personList.remove(at: i)
                                        self.personList.insert(currentPersonListObj, at: i)
                                    }
                                }
                            }
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Successful Person List Retrieval")
                                
                                //Pass the locations array to the next view
                                //self.performSegue(withIdentifier: "locationsSegue", sender: self)
                                
                                //I need to work out how to trigger the segue to the new view from navigation view controller to table view controller.
                                // The code errors here.
                                
                                self.tableView.reloadData()
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
