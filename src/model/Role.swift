//
//  Role.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRARole) class Role: NSObject {
    var name: String?
    @objc(identifier) var id: Int = NSNotFound
    var roleDescription: String?
}
