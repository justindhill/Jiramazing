//
//  IssueAttachment.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAAttachment) public class Attachment: NSObject {
    public var url: NSURL?
    public var fileName: String?
    public var author: User?
    public var creationDate: NSDate?
    public var sizeBytes: UInt?
    public var mimeType: String?
    public var contentUrl: NSURL?
    public var thumbnailUrl: NSURL?

    init(attributes: [String: AnyObject]) {
        super.init()

        
    }
}
