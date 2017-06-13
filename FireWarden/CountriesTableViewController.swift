//
//  CountriesTableViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 13/6/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class CountriesTableViewController: UITableViewController, CountryPassBackDelegate {
    
    var countriesArray = [Country]()
    var currentCountry = Country()
    var selectedRowIndex: Int32! = 0

    @IBAction func addCountryTapped(_ sender: Any) {
        prepareForCountryDetailSegue(segueIdentifier: "addCountrySegue")
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
        return countriesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)

        // Configure the cell...
        let currentCountry = self.countriesArray[indexPath.row]
        
        cell.textLabel?.text = currentCountry.country

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCountry = countriesArray[indexPath.row]
        self.selectedRowIndex = Int32(indexPath.row)
        prepareForCountryDetailSegue(segueIdentifier: "countryDetailSegue")
    }
    
    func prepareForCountryDetailSegue(segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene = segue.destination as! CountriesDetailViewController
        nextScene.delegate = self
        if segue.identifier == "countryDetailSegue" {
            nextScene.currentCountry = self.currentCountry
            nextScene.existingArrayIndex = self.selectedRowIndex
            nextScene.isExistingRecord = true
        } else if segue.identifier == "addCountrySegue" {
            nextScene.currentCountry = Country()
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
    
    func passCountryDataBack(isNewRecord: Bool, arrayIndex: Int32, objectToPass: Country) {
        // Add a UITableViewCell to the table and add the new location to the locations array
        if isNewRecord {
            //do new record addition of cell
            countriesArray.append(objectToPass)
            tableView.reloadData()
        } else {
            // Update the existing cell and the array
            countriesArray.remove(at: Int(arrayIndex))
            countriesArray.insert(objectToPass, at: Int(arrayIndex))
            tableView.reloadData()
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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
