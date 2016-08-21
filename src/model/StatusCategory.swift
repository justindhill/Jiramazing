//
//  StatusCategory.swift
//  Pods
//
//  Created by Justin Hill on 8/19/16.
//
//

import Foundation

@objc(JRAStatusCategory) public class StatusCategory: NSObject {
    @objc(identifier) public var id: String?
    public var url: NSURL?
    public var key: String?
    public var name: String?
    public var colorName: String?

    init(attributes: [String: AnyObject]) {
        super.init()

        if let urlString = attributes["self"] as? String {
            self.url = NSURL(string: urlString)
        }

        self.name = attributes["name"] as? String
        self.id = attributes["id"] as? String
        self.key = attributes["key"] as? String
        self.colorName = attributes["colorName"] as? String
    }
}
