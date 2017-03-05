//
//  LoggedInViewController.swift
//  Auth0WebAuth
//
//  Created by Pushp Abrol on 11/2/16.
//  Copyright © 2016 Pushp Abrol. All rights reserved.
//

import UIKit
import Alamofire
import Auth0
import JWTDecode
import Foundation
class LoggedInViewController : UIViewController {
    
    
    @IBAction func launchAppWithSSO(_ sender: Any) {
        
        let stringUrl = "com.auth0.App2SSO://pushp.auth0.com/ios/com.auth0.App2SSO/callback"
        
        
        let urlwithPercentEscapes = stringUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        
        
        
        let url = URL(string: urlwithPercentEscapes!)!
        
        
        
        
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

        
    }
    @IBAction func launchWebsite(_ sender: UIButton) {
        
        
        let stringUrl = "https://pushp.auth0.com/authorize?client_id=SzPfnZpx0BBHOC7E5REVkIuJhVCbbqLI&audience=&response_type=token id_token&redirect_uri=https://jwt.io&scope=openid profile&nonce=3370&state=364148&connection=Username-Password-Authentication"
        
        
        let urlwithPercentEscapes = stringUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)


        
        let url = URL(string: urlwithPercentEscapes!)!



        
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

        
    }
    

    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var accessToken: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let jwt = try decode(jwt: Application.sharedInstance.keychainService.string(forKey: "idToken")!)
                
            welcomeText.text = "Signed in into App 1"
            
                        accessToken.text = "Hi " + ( (jwt.body["email"] != nil ? jwt.body["email"] : jwt.body["name"])  as! String!) + " you have logged in using Auth0 into this sample application. You now have the access_token to call the Resource API and perform actions in this application."
            
            if (jwt.body["picture"] != nil)
            
            {
            URLSession.shared.dataTask(with: URL(string : jwt.body["picture"] as! String)!, completionHandler: { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data , error == nil else { return }
                    self.profileImage.image = UIImage(data: data)

                }
            }).resume()
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
            let alertController = UIAlertController(title: "JWT Decode error", message:
                error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }

        
    }
    @IBOutlet weak var profileImage: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func invokeApi(_ sender: AnyObject) {
        let app = Application.sharedInstance
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Application.sharedInstance.keychainService.string(forKey: "accessToken")!        ]
        Alamofire.request(app.securePingURL.absoluteString!, headers:headers).responseString { response in
            print("Success: \(response.result.isSuccess)")
            if(response.result.isSuccess)
            {
            print("Response String: \(response.result.value)")
            let alertController = UIAlertController(title: "Secure API message", message:
                response.result.value, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler:  nil))
            
            self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let alertController = UIAlertController(title: "Secure API message", message:
                    response.result.error.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
  
            }
        }
        
        

    }
        
    @IBAction func logout(_ sender: AnyObject) {
        Application.sharedInstance.keychainService.clearAll()
        
        let alertController = UIAlertController(title: "Logout", message:
            "Deleting tokens for now. SSO still exists..", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: {(alert: UIAlertAction) in
            self.performSegue(withIdentifier: "loginView", sender: self)
            
        
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
        
        

        
    }
}

