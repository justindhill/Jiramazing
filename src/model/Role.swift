//
//  Role.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Cocoa

@objc(JRARole) class Role: NSObject {
    var name: String?
    @objc(identifier) var id: Int = 0
    var roleDescription: String?
}
