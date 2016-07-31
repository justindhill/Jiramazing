//
//  Version.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAVersion) public class Version: NSObject {
    var url: NSURL?
    @objc(identifier) var id: String?
    var versionDescription: String?
    var name: String?
    var archived: Bool?
    var released: Bool?
    var releaseDate: NSDate?
    var overdue: Bool?
    var userReleaseDate: NSDate?
    @objc(projectIdentifier) var projectId: Int = NSNotFound

    init(attributes: [String: AnyObject]) {
    }
}
