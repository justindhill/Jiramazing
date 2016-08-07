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
    var displayName: String?
    var emailAddress: String?
    var avatarUrls: [AvatarSize: NSURL]?
    var active: Bool?
    var timeZone: NSTimeZone?
    var groupNames: [String]?
    var applicationRoles: [ApplicationRole]?

    init(attributes: [String: AnyObject]) {
        super.init()

        if let urlString = attributes["self"] as? String, let url = NSURL(string: urlString) {
            self.url = url
        }

        self.key = attributes["key"] as? String
        self.name = attributes["name"] as? String
        self.emailAddress = attributes["emailAddress"] as? String
        self.displayName = attributes["displayName"] as? String
        self.active = attributes["active"] as? Bool

        if let avatarUrls = attributes["avatarUrls"] as? [String: String] {
            self.avatarUrls = avatarUrls.avatarSizeMap()
        }

        if let timeZoneString = attributes["timeZone"] as? String {
            self.timeZone = NSTimeZone(name: timeZoneString)
        }

        if let groupsAttributes = attributes["groups"]?["items"] as? [[String: String]] {
            var groupsMap = [String: NSURL]()

            for groupAttributes in groupsAttributes {
                if let groupUrl = NSURL(string: groupAttributes["self"]) {
                    groupsMap[groupName] = groupUrl
                }
            }

            self.groups = groupsMap
        }

        if let applicationRolesAttributes = attributes["applicationRoles"]?["items"] as? [[String: AnyObject]] {
            self.applicationRoles = applicationRolesAttributes.map({ (appRoleAttributes) -> ApplicationRole in
                return ApplicationRole(attributes: appRoleAttributes)
            })
        }
    }
}
