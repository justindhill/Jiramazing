//
//  IssueType.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssueType) public class IssueType: NSObject {
    var url: NSURL?
    @objc(identifier) var id: String?
    var issueTypeDescription: String?
    var iconUrl: NSURL?
    var name: String?
    var subtask: Bool?
    @objc(avatarIdentifier) var avatarId: Int = NSNotFound

    init(attributes: [String: AnyObject]) {
    }
}
