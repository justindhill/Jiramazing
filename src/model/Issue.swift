//
//  Issue.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssue) class Issue: NSObject {
    @objc(identifier) var id: String?
    var title: String?
    var key: String?
    var url: NSURL?
    var fields: [Field]?
    var watching: IssueWatchState?
    var attachments: [Attachment]?
    var subTasks: [Issue]?
    var issueDescription: String?
    var project: Project?
    var comments: [Comment]?
    var issueLinks: [IssueLink]?
    var workLogEntries: [WorkLogEntry]?
    var timeTracking: IssueTimeTracking?
}
