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
}

public extension NSString {
    class func jiramazing_basicAuthEncodedString(username: String, password: String) -> String? {
        let data = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)
        
        if let encodedString = data?.base64EncodedStringWithOptions([]) {
            return "Basic \(encodedString)"
        }
        
        return nil
    }
}

internal extension Dictionary where Key: StringLiteralConvertible, Value: StringLiteralConvertible {
    func avatarSizeMap() -> [AvatarSize: NSURL] {
        var avatarUrls = [AvatarSize: NSURL]()

        for (sizeString, urlString) in self {
            guard let sizeString = sizeString as? String, let urlString = urlString as? String else {
                continue
            }

            let size = AvatarSize(sizeString)

            if let url = NSURL(string: urlString) where size != .Invalid {
                avatarUrls[size] = url
            }
        }

        return avatarUrls
    }
}
