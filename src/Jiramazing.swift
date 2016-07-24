//
//  Jiramazing.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation

@objc public class Jiramazing: NSObject, NSURLSessionDelegate {
    public private(set) var authenticated: Bool = false
    private var urlSession: NSURLSession!

    @objc(sharedInstance) public static var instance = Jiramazing()

    override init() {
        super.init()

        self.urlSession = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: self,
            delegateQueue: NSOperationQueue.mainQueue()
        )
    }
}
