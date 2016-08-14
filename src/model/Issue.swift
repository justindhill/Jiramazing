//
//  Issue.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssue) public class Issue: NSObject {
    @objc(identifier) var id: String?
    var title: String?
    var key: String?
    var url: NSURL?
    var updated: Bool?
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

    init(attributes: [String: AnyObject]) {
        super.init()

        self.id = attributes["id"] as? String
        self.key = attributes["key"] as? String

        if let urlString = attributes["self"] as? String {
            self.url = NSURL(string: urlString)
        }

        guard let fieldsAttributes = attributes["fields"] else {
            return
        }

        if let attachmentsAttributes = fieldsAttributes["attachment"] as? [[String: AnyObject]] {
            self.attachments = attachmentsAttributes.map({ (attachmentAttributes) -> Attachment in
                return Attachment(attributes: attachmentAttributes)
            })
        }

        if let watchStateAttributes = fieldsAttributes["watcher"] as? [String: AnyObject] {
            self.watching = IssueWatchState(attributes: watchStateAttributes)
        }

        self.issueDescription = fieldsAttributes["description"] as? String

        if let projectAttributes = fieldsAttributes["project"] as? [String: AnyObject] {
            self.project = Project(attributes: projectAttributes)
        }

        if let commentsAttributes = fieldsAttributes["comment"] as? [[String: AnyObject]] {
            self.comments = commentsAttributes.map({ (commentAttributes) -> Comment in
                return Comment(attributes: commentAttributes)
            })
        }

        if let workLogsAttributes = fieldsAttributes["worklog"] as? [[String: AnyObject]] {
            self.workLogEntries = workLogsAttributes.map({ (workLogAttributes) -> WorkLogEntry in
                return WorkLogEntry(attributes: workLogAttributes)
            })
        }

        if let updated = fieldsAttributes["updated"] as? Int {
            self.updated = Bool(updated)
        }

        if let timeTrackingAttributes = fieldsAttributes["timetracking"] as? [String: AnyObject] {
            self.timeTracking = IssueTimeTracking(attributes: timeTrackingAttributes)
        }
    }
}
