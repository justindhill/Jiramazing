//
//  IssueLinkType.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAIssueLinkType) public class IssueLinkType: NSObject {
    @objc(identifier) var id: String?
    var name: String?
    var inward: String?
    var outward: String?
    var url: NSURL?
}
