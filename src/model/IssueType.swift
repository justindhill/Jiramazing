//
//  IssueType.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssueType) public class IssueType: NSObject {
    public var url: NSURL?
    @objc(identifier) public var id: String?
    public var issueTypeDescription: String?
    public var iconUrl: NSURL?
    public var name: String?
    public var subtask: Bool?
    @objc(avatarIdentifier) public var avatarId: Int = NSNotFound

    init(attributes: [String: AnyObject]) {
        super.init()
    }
}
