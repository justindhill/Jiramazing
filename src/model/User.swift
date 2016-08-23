//
//  User.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAUser) public class User: NSObject, NSCoding {
    public var url: NSURL?
    public var key: String?
    public var name: String?
    public var displayName: String?
    public var emailAddress: String?
    public var avatarUrls: [AvatarSize: NSURL]?
    public var active: Bool?
    public var timeZone: NSTimeZone?
    public var groupNames: [String]?
    public var applicationRoles: [ApplicationRole]?

    private let UrlKey = "url"
    private let KeyKey = "key"
    private let NameKey = "name"
    private let DisplayNameKey = "displayName"
    private let EmailKey = "email"
    private let AvatarUrlsKey = "avatarUrls"
    private let ActiveKey = "active"
    private let TimeZoneKey = "timeZone"
    private let GroupNamesKey = "groupNames"
    private let ApplicationRolesKey = "applicationRoles"

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
            var groupNames = [String]()

            for groupAttributes in groupsAttributes {
                if let groupName = groupAttributes["name"] {
                    groupNames.append(groupName)
                }
            }

            self.groupNames = groupNames
        }

        if let applicationRolesAttributes = attributes["applicationRoles"]?["items"] as? [[String: AnyObject]] {
            self.applicationRoles = applicationRolesAttributes.map({ (appRoleAttributes) -> ApplicationRole in
                return ApplicationRole(attributes: appRoleAttributes)
            })
        }
    }

    public required init?(coder d: NSCoder) {
        super.init()

        self.url = d.decodeObjectForKey(UrlKey) as? NSURL
        self.key = d.decodeObjectForKey(KeyKey) as? String
        self.name = d.decodeObjectForKey(NameKey) as? String
        self.displayName = d.decodeObjectForKey(DisplayNameKey) as? String
        self.emailAddress = d.decodeObjectForKey(EmailKey) as? String

        // WARNING: AvatarUrls not encoded

        self.active = d.decodeObjectForKey(ActiveKey) as? Bool
        self.timeZone = d.decodeObjectForKey(TimeZoneKey) as? NSTimeZone
        self.groupNames = d.decodeObjectForKey(GroupNamesKey) as? [String]
        self.applicationRoles = d.decodeObjectForKey(ApplicationRolesKey) as? [ApplicationRole]
    }

    public func encodeWithCoder(c: NSCoder) {
        c.encodeObject(self.url, forKey: UrlKey)
        c.encodeObject(self.key, forKey: KeyKey)
        c.encodeObject(self.displayName, forKey: DisplayNameKey)
        c.encodeObject(self.emailAddress, forKey: EmailKey)

        // WARNING: AvatarUrls not encoded

        c.encodeObject(self.active, forKey: ActiveKey)
        c.encodeObject(self.timeZone, forKey: TimeZoneKey)
        c.encodeObject(self.groupNames, forKey: GroupNamesKey)
        c.encodeObject(self.applicationRoles, forKey: ApplicationRolesKey)
    }
}
