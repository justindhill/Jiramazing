//
//  IssueLink.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssueLink) public class IssueLink: NSObject {
    @objc(identifier) var id: String?
    var type: IssueType?
    var inwardIssue: Issue?
    var outwardIssue: Issue?
}
