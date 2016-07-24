//
//  User.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAUser) public class User: NSObject {
    var url: NSURL?
    var key: String?
    var name: String?
    var emailAddress: String?
    var avatarUrls: [AvatarSize: NSURL]?
    var active: Bool?
    var timeZone: NSTimeZone?
    var groups: [String]?
    var applicationRoles: [ApplicationRole]?
}
