//
//  IssueField.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAField) class Field: NSObject {
    @objc(identifier) var id: String?
    var name: String?
    var custom: Bool?
    var orderable: Bool?
    var navigable: Bool?
    var searchable: Bool?
    var clauseNames: [String]?
    var schema: FieldSchema?
}
