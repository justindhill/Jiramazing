//
//  Project.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAProject) public class Project: NSObject {
    public var url: NSURL?
    @objc(identifier) var id: String?
    public var key: String?
    public var projectDescription: String?
    public var lead: User?

    // TODO: components support

    public var issueTypes: [IssueType]?

    public var browseUrl: NSURL?
    public var email: String?
    public var assigneeType: String?
    public var versions: [Version]?
    public var name: String?
    public var roles: [String: NSURL]?
    public var avatarUrls: [AvatarSize: NSURL]?
    public var category: ProjectCategory?

    init(attributes: [String: AnyObject]) {
        super.init()

        self.id = attributes["id"] as? String
        self.key = attributes["key"] as? String
        self.projectDescription = attributes["description"] as? String
        self.email = attributes["email"] as? String
        self.assigneeType = attributes["assigneeType"] as? String
        self.name = attributes["name"] as? String

        if let urlString = attributes["self"] as? String, let url = NSURL(string: urlString) {
            self.url = url
        }

        if let urlString = attributes["url"] as? String, let url = NSURL(string: urlString) {
            self.browseUrl = url
        }

        if let leadAttributes = attributes["lead"] as? [String: AnyObject] {
            self.lead = User(attributes: leadAttributes)
        }

        if let issueTypesAttributes = attributes["issueTypes"] as? [[String: AnyObject]] {
            self.issueTypes = issueTypesAttributes.map({ (issueTypeAttributes) -> IssueType in
                return IssueType(attributes: issueTypeAttributes)
            })
        }

        if let rolesAttributes = attributes["roles"] as? [String: String] {
            var roles = [String: NSURL]()

            for (roleName, roleUrlString) in rolesAttributes {
                if let roleUrl = NSURL(string: roleUrlString) {
                    roles[roleName] = roleUrl
                }
            }

            self.roles = roles
        }

        if let versionsAttributes = attributes["versions"] as? [[String: AnyObject]] {
            self.versions = versionsAttributes.map({ (versionAttributes) -> Version in
                return Version(attributes: versionAttributes)
            })
        }

        if let avatarUrlsAttributes = attributes["avatarUrls"] as? [String: String] {
            self.avatarUrls = avatarUrlsAttributes.avatarSizeMap()
        }

        if let projectCategoryAttributes = attributes["projectCategory"] as? [String: AnyObject] {
            self.category = ProjectCategory(attributes: projectCategoryAttributes)
        }
    }

    override public var description: String {
        get {
            let key = self.key ?? "nil"
            let id = self.id ?? "nil"

            return super.description.stringByAppendingString(" \(key) - \(id)")
        }
    }
}
