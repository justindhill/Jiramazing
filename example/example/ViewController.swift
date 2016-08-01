//
//  ViewController.swift
//  example
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import UIKit
import Jiramazing

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        Jiramazing.instance.baseUrl = NSURL(string: "https://worldnow.atlassian.net")!
        Jiramazing.instance.username = "justin"
        Jiramazing.instance.password = "VeZQYq$tUQAxkUnzhfzsNhr8V"
//        Jiramazing.instance.validateSession({ (success) in
//            print(success)
//            print("authenticated: \(Jiramazing.instance.authenticated)")
//        })

        Jiramazing.instance.getProject("18100") { (project, error) in
            dump(project)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

