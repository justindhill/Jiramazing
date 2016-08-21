//
//  Status.swift
//  Pods
//
//  Created by Justin Hill on 8/19/16.
//
//

import Foundation

@objc(JRAStatus) public class Status: NSObject {
    @objc(identifier) public var id: String?
    public var url: NSURL?
    public var color: UIColor?
    public var statusDescription: String?
    public var name: String?
    public var statusCategory: StatusCategory?
    public var iconUrl: NSURL?

    init(attributes: [String: AnyObject]) {
        super.init()

        if let urlString = attributes["self"] as? String {
            self.url = NSURL(string: urlString)
        }

        if let colorString = attributes["statusColor"] as? String {
            self.color = UIColor.hx_colorWithHexString(colorString)
        }

        self.statusDescription = attributes["description"] as? String
        self.name = attributes["name"] as? String
        self.id = attributes["id"] as? String

        if let statusCategoryAttributes = attributes["statusCategory"] as? [String: AnyObject] {
            self.statusCategory = StatusCategory(attributes: statusCategoryAttributes)
        }

        if let iconUrlString = attributes["iconUrl"] as? String {
            self.iconUrl = NSURL(string: iconUrlString)
        }
    }
}
