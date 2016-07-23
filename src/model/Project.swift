//
//  Project.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAProject) class Project: NSObject {
    var url: NSURL?
    @objc(identifier) var id: String?
    var key: String?
    var projectDescription: String?
    var lead: User?

    // TODO: components support

    var issueTypes: [IssueType]?

    // TODO: browse URL?

    var browseUrl: NSURL?
    var email: String?
    var assigneeType: String?
    var versions: [Version]?
    var name: String?
    var roles: [Role]?

    // TODO: avatar URLs
    
    var category: ProjectCategory?
}
