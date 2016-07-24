//
//  IssueTimeTracking.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssueTimeTracking) public class IssueTimeTracking: NSObject {
    var originalEstimateString: String?
    var remainingEstimateString: String?
    var timeSpentString: String?
    var originalEstimate: NSTimeInterval?
    var remainingEstimate: NSTimeInterval?
    var timeSpent: NSTimeInterval?
}
