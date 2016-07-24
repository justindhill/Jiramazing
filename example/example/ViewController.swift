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

        print("authenticated: \(Jiramazing.instance.authenticated)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

