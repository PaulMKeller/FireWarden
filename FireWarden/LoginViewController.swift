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
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if shouldPerformSegue(withIdentifier: "loginSegue", sender: self) == false {
            return
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return submitDetails()
    }
 */
    
    func submitDetails(){
        
        self.view.endEditing(true)
        self.errorText.text = ""
        
        
        let url:URL = URL(string: "http://www.gratuityp.com/pk/GetLoginDetails.php")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let paramString = "LoginName=" + loginName.text!
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print(dataString)
            if dataString!.lowercased.range(of: "error") != nil {
                //self.activityView.stopAnimating()
                self.errorText.text = "ERROR: Check entries and try again."
            } else {
                //self.activityView.stopAnimating()
                //self.errorText.text = "Details returned..."
                self.validateLogin(loginJson: dataString!)
            }
        })
        
        task.resume()
        
    }
    
    func validateLogin(loginJson:NSString) {
        
    }

}
