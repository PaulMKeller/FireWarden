//
//  LoginViewController.swift
//  FireWarden
//
//  Created by Paul Keller on 26/4/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorText: UILabel!
    @IBAction func loginAttempt(_ sender: Any) {
        submitDetails()
    }
    
    @IBAction func useTouchID(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //if shouldPerformSegue(withIdentifier: "loginSegue", sender: self) == false {
        //    return
        //}
        

    }

/*
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return submitDetails()
    }
*/
    func submitDetails() {
        let url = URL(string: "http://www.gratuityp.com/pk/GetLoginDetails.php")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
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
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print(myJson)
                        
                        let loginArray = myJson[0] as! NSDictionary
                        let loginDetails = Login(loginID:loginArray["LoginID"] as! Int32, loginName:loginArray["LoginName"] as! String,password:loginArray["Password"] as! String,adminRole:"")
                        
                        if self.validLoginDetails(loginRecord: loginDetails) {
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                        }
                    }
                    catch
                    {
                        //print(error)
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
