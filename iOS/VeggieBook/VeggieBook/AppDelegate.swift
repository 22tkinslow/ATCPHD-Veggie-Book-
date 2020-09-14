//
//  AppDelegate.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 12/15/16.
//  Copyright © 2016 DiPasquo Consulting. All rights reserved.
//

import UIKit

#if STANDARD
let APP_VERSION = "STANDARD"
#endif

#if MFF
let APP_VERSION = "MFF"
#endif

#if CHI
let APP_VERSION = "CHI"
#endif



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // [START didfinishlaunching]
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(APP_VERSION)
        return true
    }
    // [END didfinishlaunching]
    
    // [START openurl]
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    // [END openurl]
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
}

