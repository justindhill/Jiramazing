//
//  ApplicationRole.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAApplicationRole) public class ApplicationRole: NSObject {
    var key: String?
    var groups: [String]?
    var name: String?
    var defaultGroups: [String]?
    var selectedByDefault: Bool?
    var defined: Bool?
    var numberOfSeats: Int?
    var remainingSeats: Int?
    var userCount: Int?
    var userCountDescription: String?
    var hasUnlimitedSeats: Bool?
    var platform: Bool?

    init(attributes: [String: AnyObject]) {
    }
}
