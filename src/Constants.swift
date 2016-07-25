//
//  Constants.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc(JRAAvatarSize) public enum AvatarSize: Int {
    case Invalid
    case ExtraSmall
    case Small
    case Medium
    case Large
}

@objc(JRAAuthenticationMethod) public enum AuthenticationMethod: Int {
    case Unauthenticated
    case OAuth
    case Basic
}