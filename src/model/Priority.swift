//
//  Priority.swift
//  Pods
//
//  Created by Justin Hill on 8/19/16.
//
//

import Foundation
import HexColors

@objc(JRAPriority) public class Priority: NSObject {
    @objc(identifier) public var id: String?
    public var url: NSURL?
    public var color: UIColor?
    public var priorityDescription: String?
    public var name: String?

    init(attributes: [String: AnyObject]) {
        super.init()

        if let urlString = attributes["self"] as? String {
            self.url = NSURL(string: urlString)
        }

        if let colorString = attributes["statusColor"] as? String {
            self.color = UIColor.hx_colorWithHexString(colorString)
        }

        self.priorityDescription = attributes["description"] as? String
        self.name = attributes["name"] as? String
        self.id = attributes["id"] as? String
    }
}
