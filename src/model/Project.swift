//
//  Project.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAProject) public class Project: NSObject, NSCoding {
    public var url: NSURL?
    @objc(identifier) public var id: String?
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

    // Coding keys
    private let UrlKey = "url"
    private let IdKey = "id"
    private let KeyKey = "key"
    private let DescriptionKey = "description"
    private let LeadKey = "lead"
    private let IssueTypesKey = "issueTypes"
    private let BrowseUrlKey = "browseUrl"
    private let EmailKey = "emailKey"
    private let AssigneeTypeKey = "assigneeType"
    private let VersionsKey = "versions"
    private let NameKey = "name"
    private let RolesKey = "roles"
    private let AvatarUrlsKey = "avatarUrls"
    private let CategoryKey = "category"

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

    public required init?(coder d: NSCoder) {
        super.init()

        self.url = d.decodeObjectForKey(UrlKey) as? NSURL
        self.id = d.decodeObjectForKey(IdKey) as? String
        self.key = d.decodeObjectForKey(KeyKey) as? String
        self.projectDescription = d.decodeObjectForKey(DescriptionKey) as? String
        self.lead = d.decodeObjectForKey(LeadKey) as? User
        self.issueTypes = d.decodeObjectForKey(IssueTypesKey) as? [IssueType]
        self.browseUrl = d.decodeObjectForKey(BrowseUrlKey) as? NSURL
        self.email = d.decodeObjectForKey(EmailKey) as? String
        self.assigneeType = d.decodeObjectForKey(AssigneeTypeKey) as? String
        self.versions = d.decodeObjectForKey(VersionsKey) as? [Version]
        self.name = d.decodeObjectForKey(NameKey) as? String
        self.roles = d.decodeObjectForKey(RolesKey) as? [String: NSURL]
        
        if let decodableUrls = d.decodeObjectForKey(AvatarUrlsKey) as? [Int: NSURL] {
            var decodedUrls = [AvatarSize: NSURL]()
            
            for (key, value) in decodableUrls {
                if let avatarSize = AvatarSize(rawValue: key) {
                    decodedUrls[avatarSize] = value
                }
            }
            
            self.avatarUrls = decodedUrls
        }

        self.category = d.decodeObjectForKey(CategoryKey) as? ProjectCategory
    }

    override public var description: String {
        get {
            let key = self.key ?? "nil"
            let id = self.id ?? "nil"

            return super.description.stringByAppendingString(" \(key) - \(id)")
        }
    }

    public func encodeWithCoder(c: NSCoder) {
        c.encodeObject(self.url, forKey: UrlKey)
        c.encodeObject(self.id, forKey: IdKey)
        c.encodeObject(self.key, forKey: KeyKey)
        c.encodeObject(self.projectDescription, forKey: DescriptionKey)
        c.encodeObject(self.lead, forKey: LeadKey)
        c.encodeObject(self.issueTypes, forKey: IssueTypesKey)
        c.encodeObject(self.browseUrl, forKey: BrowseUrlKey)
        c.encodeObject(self.email, forKey: EmailKey)
        c.encodeObject(self.assigneeType, forKey: AssigneeTypeKey)
        c.encodeObject(self.versions, forKey: VersionsKey)
        c.encodeObject(self.name, forKey: NameKey)
        c.encodeObject(self.roles, forKey: RolesKey)

        if let avatarUrls = self.avatarUrls {
            var encodableUrls = [Int: NSURL]()
            for (key, value) in avatarUrls {
                encodableUrls[key.rawValue] = value
            }
            
            c.encodeObject(encodableUrls, forKey: AvatarUrlsKey)
        } else {
            c.encodeObject(nil, forKey: AvatarUrlsKey)
        }

        c.encodeObject(self.category, forKey: CategoryKey)
    }
}
