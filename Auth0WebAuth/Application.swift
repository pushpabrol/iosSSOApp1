//
//  Application.swift
//  Auth0WebAuth
//
//  Created by Pushp Abrol on 11/3/16.
//  Copyright © 2016 Pushp Abrol. All rights reserved.
//

import Foundation
import SimpleKeychain
class Application {
    
    static var sharedInstance = Application()
    
    var audience: String?
    var securePingURL: NSURL
    var domain : String?
    var API_AUDIENCE : String?
    var scope : String?
    var keychainService : A0SimpleKeychain
    private init() {
        
        var path = Bundle.main.path(forResource: "Info", ofType: "plist")
        var dict = NSDictionary(contentsOfFile: path!)
        self.keychainService = A0SimpleKeychain.init(service: "Auth0", accessGroup: "com.auth0.Auth0WebAuth");
        let urlString = dict!.object(forKey: "APIUrl") as! String
        let baseURL = NSURL(string: urlString)
        self.securePingURL = NSURL(string: "/api/secured", relativeTo: baseURL as URL?)!
        path = Bundle.main.path(forResource: "Auth0", ofType: "plist")
        dict = NSDictionary(contentsOfFile: path!)
        self.audience = dict!.object(forKey: "ClientId") as? String
        self.domain = dict!.object(forKey: "Domain") as? String
        self.API_AUDIENCE = dict!.object(forKey: "API_AUDIENCE") as? String
        self.scope = dict!.object(forKey: "scope") as? String

    }
    
    
}

