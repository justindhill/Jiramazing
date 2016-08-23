//
//  ProjectCategory.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAProjectCategory) public class ProjectCategory: NSObject, NSCoding {
    var url: NSURL?
    @objc(identifier) var id: String?
    var name: String?
    var projectCategoryDescription: String?

    private let UrlKey = "url"
    private let IdKey = "id"
    private let NameKey = "name"
    private let DescriptionKey = "description"

    init(attributes: [String: AnyObject]) {
        super.init()
    }

    required public init?(coder d: NSCoder) {
        super.init()

        self.url = d.decodeObjectForKey(UrlKey) as? NSURL
        self.id = d.decodeObjectForKey(IdKey) as? String
        self.name = d.decodeObjectForKey(NameKey) as? String
        self.projectCategoryDescription = d.decodeObjectForKey(DescriptionKey) as? String
    }

    public func encodeWithCoder(c: NSCoder) {
        c.encodeObject(self.url, forKey: UrlKey)
        c.encodeObject(self.id, forKey: IdKey)
        c.encodeObject(self.name, forKey: NameKey)
        c.encodeObject(self.projectCategoryDescription, forKey: DescriptionKey)
    }
}
