//
//  Comment.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAComment) class Comment: NSObject {
    var url: NSURL?
    @objc(identifier) var id: String?
    var author: User?
    var body: String?
    var updateAuthor: User?
    var creationDate: NSDate?
    var lastUpdated: NSDate?
    var visibility: Visibility?
}
