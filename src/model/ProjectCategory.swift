//
//  ProjectCategory.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAProjectCategory) class ProjectCategory: NSObject {
    var url: String?
    @objc(identifier) var id: String?
    var name: String?
    var projectCategoryDescription: String?
}
