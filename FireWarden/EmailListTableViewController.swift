//
//  EmailListTableViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 21/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class EmailListTableViewController: UITableViewController, SettingPassBackDelegate {

    var emailAddresses = [SettingTypeObj]()
    var currentEmail = SettingTypeObj()
    var selectedRowIndex: Int32! = 0
    var isExistingRecord: Bool = true
    
    @IBAction func addTapped(_ sender: Any) {
        prepareForEmailDetailSegue(segueIdentifier: "addEmailSegue")
    }
    
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
        return emailAddresses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath)

        // Configure the cell...
        let cellSetting: SettingTypeObj = emailAddresses[indexPath.row]
        cell.textLabel?.text = cellSetting.settingValue

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentEmail = emailAddresses[indexPath.row]
        self.selectedRowIndex = Int32(indexPath.row)
        prepareForEmailDetailSegue(segueIdentifier: "emailDetailSegue")
    }
    
    func prepareForEmailDetailSegue(segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene = segue.destination as! EmailDetailListViewController
        nextScene.delegate = self
        if segue.identifier == "emailDetailSegue" {
            nextScene.currentEmail = self.currentEmail
            nextScene.existingArrayIndex = self.selectedRowIndex
            nextScene.isExistingRecord = true
        } else if segue.identifier == "addEmailSegue" {
            nextScene.currentEmail = SettingTypeObj()
            nextScene.isExistingRecord = false
            nextScene.existingArrayIndex = 0
        }
    }
    
    func passSettingDataBack(isNewRecord: Bool, arrayIndex: Int32, objectToPass: SettingTypeObj) {
        // Add a UITableViewCell to the table and add the new location to the locations array
        if isNewRecord {
            //do new record addition of cell
            emailAddresses.append(objectToPass)
            tableView.reloadData()
        } else {
            // Update the existing cell and the array
            emailAddresses.remove(at: Int(arrayIndex))
            emailAddresses.insert(objectToPass, at: Int(arrayIndex))
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
