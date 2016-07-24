//
//  WorkLogEntry.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAWorkLogEntry) class WorkLogEntry: NSObject {
    var url: NSURL?
    var author: User?
    var updateAuthor: User?
    var comment: String?
    var lastUpdated: NSDate?
    var visibility: Visibility?
    var started: NSDate?
    var timeSpentString: String?
    var timeSpent: NSTimeInterval?
    @objc(identifier) var id: String?
    @objc(issueIdentifier) var issueId: String?
    
}
