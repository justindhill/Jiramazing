//
//  IssueWatchState.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssueWatchState) public class IssueWatchState: NSObject {
    var watching: Bool?
    var watchers: [User]?

    init(attributes: [String: AnyObject]) {
        super.init()
    }
}
