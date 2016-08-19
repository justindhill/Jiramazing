//
//  IssueRelationType.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssueRelationType) public class IssueRelationType: NSObject {
    var url: NSURL?
    @objc(identifier) var id: String?
    var issueTypeDescription: String?
    var iconUrl: NSURL?
    var name: String?
    var subtask: Bool?
    @objc(avatarIdentifier) var avatarId: Int = NSNotFound

    init(attributes: [String: AnyObject]) {
        super.init()
    }
}
