//
//  LoginViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 26/4/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func loginAttempt(_ sender: Any) {
        self.errorText.text = ""
        submitDetails()
    }
    
    @IBAction func useTouchID(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.activityIndicator.stopAnimating()
        loginName.delegate = self
        password.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //if shouldPerformSegue(withIdentifier: "loginSegue", sender: self) == false {
        //    return
        //}
        

    }


    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return submitDetails()
    }
*/
    

    func submitDetails() {
        self.activityIndicator.startAnimating()
        let url = URL(string: "http://www.gratuityp.com/pk/GetLoginDetails.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "LoginName=" + loginName.text!
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
                            let loginArray = myJson[0] as! NSDictionary
                            let accessRights = myJson[1] as! NSDictionary
                            print(accessRights)
                            let loginDetails = Login(loginID:loginArray["LoginID"] as! Int32, loginName:loginArray["LoginName"] as! String,password:loginArray["Password"] as! String,adminRole:accessRights)
                            
                            if self.validLoginDetails(loginRecord: loginDetails) {
                                DispatchQueue.main.async(execute: {
                                    self.activityIndicator.stopAnimating()
                                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                                })
                            }
                            else
                            {
                                DispatchQueue.main.async(execute: {
                                    self.activityIndicator.stopAnimating()
                                    self.errorText.text = "Login Name or Password failure."
                                })
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                self.activityIndicator.stopAnimating()
                                self.errorText.text = "Invalid Credentials Supplied"
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
    
    func validLoginDetails(loginRecord: Login) -> Bool {
        
        if loginRecord.password==self.password.text {
            return true
        }
        else
        {
            return false
        }
        
    }
}
