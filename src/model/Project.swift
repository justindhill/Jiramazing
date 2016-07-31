//
//  Project.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAProject) public class Project: NSObject {
    var url: NSURL?
    @objc(identifier) var id: String?
    var key: String?
    var projectDescription: String?
    var lead: User?

    // TODO: components support

    var issueTypes: [IssueType]?

    var browseUrl: NSURL?
    var email: String?
    var assigneeType: String?
    var versions: [Version]?
    var name: String?
    var roles: [String: Role]?
    var avatarUrls: [AvatarSize: NSURL]?
    var category: ProjectCategory?

    init(attributes: [String: AnyObject]) {
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

        if let rolesAttributes = attributes["roles"] as? [String: AnyObject] {
            var roles = [String: Role]()

            for (roleName, roleAttributes) in rolesAttributes {
                if let roleAttributes = roleAttributes as? [String: AnyObject] {
                    roles[roleName] = Role(attributes: roleAttributes)
                }
            }

            self.roles = roles
        }

        if let versionsAttributes = attributes["versions"] as? [[String: AnyObject]] {
            self.versions = versionsAttributes.map({ (versionAttributes) -> Version in
                return Version(attributes: versionAttributes)
            })
        }

        if let avatarUrlsAttributes = attributes["avatarUrls"] as? [String: AnyObject] {
            var avatarUrls = [AvatarSize: NSURL]()

            for (sizeString, urlString) in avatarUrlsAttributes {
                let size = AvatarSize(sizeString)

                if let urlString = urlString as? String, let url = NSURL(string: urlString) where size != .Invalid {
                    avatarUrls[size] = url
                }
            }

            self.avatarUrls = avatarUrls
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
