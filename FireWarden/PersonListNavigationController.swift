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
                                let wardenCountObj = WardenCount(wardenID: obj["WardenID"] as! Int32, firstName: obj["FirstName"] as! String, lastName: obj["LastName"] as! String, personCount: obj["PersonCount"] as! Int32, sectionNumber: obj["SectionNumber"] as! Int32)
                                print(wardenCountObj)
                                self.wardenList.append(wardenCountObj)
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
