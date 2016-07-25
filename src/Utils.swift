//
//  Utils.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

internal extension String {
    func avatarSize() -> AvatarSize {
        switch self {
        case "48x48":
            return .Large
        case "32x32":
            return .Medium
        case "24x24":
            return .Small
        case "16x16":
            return .ExtraSmall
        default:
            return .Invalid
        }
    }

    static func basicAuthEncodedString(username: String, password: String) -> String? {
        let data = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)
        return data?.base64EncodedStringWithOptions([])
    }
}
