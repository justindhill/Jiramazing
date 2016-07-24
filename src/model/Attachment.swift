//
//  IssueAttachment.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAAttachment) public class Attachment: NSObject {
    var url: NSURL?
    var fileName: String?
    var author: User?
    var creationDate: NSDate?
    var sizeBytes: UInt?
    var mimeType: String?
    var contentUrl: NSURL?
    var thumbnailUrl: NSURL?
}
