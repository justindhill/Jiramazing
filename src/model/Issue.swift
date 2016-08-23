//
//  Issue.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation
import ISO8601

@objc(JRAIssue) public class Issue: NSObject, NSCopying {
    @objc(identifier) public var id: String?
    public var key: String?
    public var url: NSURL?
    public var updated: Bool?
    public var watching: IssueWatchState?
    public var attachments: [Attachment]?
    public var subTasks: [Issue]?
    public var issueDescription: String?
    public var project: Project?
    public var comments: [Comment]?
    public var issueLinks: [IssueLink]?
    public var workLogEntries: [WorkLogEntry]?
    public var timeTracking: IssueTimeTracking?
    public var priority: Priority?
    public var status: Status?
    public var creator: User?
    public var assignee: User?
    public var dueDate: NSDate?
    public var summary: String?

    public var issueType: IssueType?
    public var timeSpent: Int?
    public var timeOriginalEstimate: Int?
    public var progress: Int?
    public var progressTotal: Int?
    public var aggregateTimeSpent: Int?
    public var aggregateTimeOriginalEstimate: Int?
    public var aggregateProgress: Int?
    public var aggregateProgressTotal: Int?
    public var fixVersions: [Version]?
    public var affectedVersions: [Version]?
    public var resolutionDate: NSDate?
    public var workRatio: Float?
    public var lastViewedOn: NSDate?
    public var createdOn: NSDate?
    public var updatedOn: NSDate?
    public var reporter: User?
    public var votes: Int?
    public var hasVoted: Bool?

    override init() {
        super.init()
    }

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

        self.summary = fieldsAttributes["summary"] as? String

        if let attachmentsAttributes = fieldsAttributes["attachment"] as? [[String: AnyObject]] {
            self.attachments = attachmentsAttributes.map({ (attachmentAttributes) -> Attachment in
                return Attachment(attributes: attachmentAttributes)
            })
        }

        self.timeSpent = fieldsAttributes["timespent"] as? Int
        self.timeOriginalEstimate = fieldsAttributes["timeoriginalestimate"] as? Int

        if let progressAttributes = fieldsAttributes["progress"] as? [String: AnyObject] {
            self.progress = progressAttributes["progress"] as? Int
            self.progressTotal = progressAttributes["total"] as? Int
        }

        self.aggregateTimeSpent = fieldsAttributes["aggregatetimespent"] as? Int
        self.aggregateTimeOriginalEstimate = fieldsAttributes["aggregatetimeoriginalestimate"] as? Int

        if let aggregateProgressAttributes = fieldsAttributes["aggregateprogress"] as? [String: AnyObject] {
            self.aggregateProgress = aggregateProgressAttributes["progress"] as? Int
            self.aggregateProgressTotal = aggregateProgressAttributes["total"] as? Int
        }

        if let fixVersionsAttributes = fieldsAttributes["fixVersions"] as? [[String: AnyObject]] {
            self.fixVersions = fixVersionsAttributes.map({ (fixVersionAttributes) -> Version in
                return Version(attributes: fixVersionAttributes)
            })
        }

        if let watchStateAttributes = fieldsAttributes["watcher"] as? [String: AnyObject] {
            self.watching = IssueWatchState(attributes: watchStateAttributes)
        }

        self.issueDescription = fieldsAttributes["description"] as? String

        if let projectAttributes = fieldsAttributes["project"] as? [String: AnyObject] {
            self.project = Project(attributes: projectAttributes)
        }

        if let issueTypeAttributes = fieldsAttributes["issuetype"] as? [String: AnyObject] {
            self.issueType = IssueType(attributes: issueTypeAttributes)
        }

        if let commentsContainer = fieldsAttributes["comment"] as? [String: AnyObject],
               commentsAttributes = commentsContainer["comments"] as? [[String: AnyObject]] {
            self.comments = commentsAttributes.map({ (commentAttributes) -> Comment in
                return Comment(attributes: commentAttributes)
            })
        }

        if let workLogsAttributes = fieldsAttributes["worklog"] as? [[String: AnyObject]] {
            self.workLogEntries = workLogsAttributes.map({ (workLogAttributes) -> WorkLogEntry in
                return WorkLogEntry(attributes: workLogAttributes)
            })
        }

        if let priorityAttributes = fieldsAttributes["priority"] as? [String: AnyObject] {
            self.priority = Priority(attributes: priorityAttributes)
        }

        if let statusAttributes = fieldsAttributes["status"] as? [String: AnyObject] {
            self.status = Status(attributes: statusAttributes)
        }

        if let updated = fieldsAttributes["updated"] as? Int {
            self.updated = Bool(updated)
        }

        if let timeTrackingAttributes = fieldsAttributes["timetracking"] as? [String: AnyObject] {
            self.timeTracking = IssueTimeTracking(attributes: timeTrackingAttributes)
        }

        if let creatorAttributes = fieldsAttributes["creator"] as? [String: AnyObject] {
            self.creator = User(attributes: creatorAttributes)
        }

        if let assigneeAttributes = fieldsAttributes["assignee"] as? [String: AnyObject] {
            self.assignee = User(attributes: assigneeAttributes)
        }

        if let dueDateString = fieldsAttributes["duedate"] as? String {
            self.dueDate = NSDate(ISO8601String: dueDateString)
        }
    }

    public func copyWithZone(zone: NSZone) -> AnyObject {
        return Issue()
    }
}
