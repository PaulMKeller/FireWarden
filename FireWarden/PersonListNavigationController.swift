//
//  PersonListNavigationController.swift
//  FireWarden
//
//  Created by Paul Keller on 27/4/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class PersonListNavigationController: UINavigationController {
    
    var wardenList = [WardenCount]()
    var personList = [PersonListObj]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareForNavigationSegue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareForNavigationSegue() {
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }

}
