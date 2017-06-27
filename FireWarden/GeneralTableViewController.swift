//
//  GeneralTableViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 21/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class GeneralTableViewController: UITableViewController {
    
    var settingsData = [String]()
    var emailAddresses = [SettingTypeObj]()
    var selectedRowIndex: Int32! = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //settingsData.append("Email List")
        //settingsData.append("More Settings Will Go Here?")
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
        return settingsData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        var cellID: String = ""
        switch indexPath.row {
        case 0:
            cellID = "emailCell"
        case 1:
            cellID = "etcCell"
        default:
            break
        }
        */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = settingsData[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //call countries code
            prepareForEmailSegue(settingType: "Email")
        case 1:
            prepareForEtcSegue()
        default:
            // Return an error...
            break
        }
    }
    
    func prepareForEmailSegue(settingType: String) {
        let waitingView = showWaitingView(tableView: tableView)
        
        let url = URL(string: "http://www.gratuityp.com/pk/SettingsGet.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var postString = "SettingType=" + settingType
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
                            self.emailAddresses.removeAll()
                            for item in myJson {
                                let obj = item as! NSDictionary
                                let emailAddress = SettingTypeObj()
                                emailAddress.settingID = obj["SettingID"] as! Int32
                                emailAddress.settingType = obj["SettingType"] as! String
                                emailAddress.settingKey = obj["SettingKey"] as! String
                                emailAddress.settingValue = obj["SettingValue"] as! String
                                
                                print(emailAddress)
                                self.emailAddresses.append(emailAddress)
                            }
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Successful Email Retrieval")
                                
                                //Pass the locations array to the next view
                                self.performSegue(withIdentifier: "emailListSegue", sender: self)
                                
                            })
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                //self.activityIndicator.stopAnimating()
                                //self.errorText.text = "Invalid Credentials Supplied"
                                print("Un-Successful Email Retrieval")
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
    
    func prepareForEtcSegue() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene = segue.destination as! EmailListTableViewController
        if segue.identifier == "emailListSegue" {
            nextScene.emailAddresses = self.emailAddresses
            nextScene.isExistingRecord = true
        }
        /*else if segue.identifier == "addEmailSegue" {
            nextScene.emailAddresses = [String]()
            nextScene.isExistingRecord = false
        }*/
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
