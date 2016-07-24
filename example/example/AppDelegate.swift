//
//  AppDelegate.swift
//  example
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import UIKit
import Jiramazing

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window?.makeKeyAndVisible()

        return true
    }
}

