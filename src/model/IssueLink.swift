//
//  IssueLink.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssueRelation) public class IssueRelation: NSObject {
    @objc(identifier) var id: String?
    var type: IssueRelationType?
    var inwardIssue: Issue?
    var outwardIssue: Issue?
}
