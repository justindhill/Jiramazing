//
//  Jiramazing.swift
//  Jiramazing
//
//  Created by Justin Hill on 7/23/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

import Foundation
import Dispatch

@objc(JRAErrorCode) public enum ErrorCode: Int {
    case Unauthenticated
    case BaseUrlNotSet
    case InvalidParameter
    case MalformedBaseUrl
    case MalformedPath
    case MalformedJSONResponse
    case UnexpectedResponseStructure
    case JSONEncodingError
}

@objc public class Jiramazing: NSObject, NSURLSessionDelegate {
    public private(set) var authenticated: Bool = false
    private var urlSession: NSURLSession!

    private static let TimeoutInterval: NSTimeInterval = 60

    public var authenticationMethod: AuthenticationMethod = .Basic
    public var username: String = ""
    public var password: String = ""
    public var baseUrl: NSURL?

    public static let ErrorDomain = "JiramazingErrorDomain"

    @objc(sharedInstance) public static var instance = Jiramazing()

    override init() {
        super.init()

        self.urlSession = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: self,
            delegateQueue: NSOperationQueue.mainQueue()
        )
    }

    // MARK: - Session
    public func validateSession(completion: (success: Bool) -> Void) {
        if let authorizationHeader = String.basicAuthEncodedString(self.username, password: self.password) {
            self.get("/rest/auth/1/session", authenticationMethod: .Unauthenticated, customHeaders:["Authorization": authorizationHeader], completion: { (responseJSONObject, error) in
                completion(success: error == nil)
            })
        } else {
            completion(success: false)
        }
    }

    // MARK: - Project
    public func getProjects(completion: (projects: [Project]?, error: NSError?) -> Void) {
        self.get("/rest/api/2/project", queryParameters: ["expand": "description,lead,url,projectKeys"]) { (data, error) in
            if let error = error {
                completion(projects: nil, error: error)
                return
            }

            if let data = data as? [[String: AnyObject]] {
                let projects = data.map({ (projectDict) -> Project in
                    return Project(attributes: projectDict)
                })

                completion(projects: projects, error: nil)
            } else {
                completion(projects: nil, error: NSError.jiramazingUnexpectedStructureError())
            }
        }
    }

    public func getProjectWithProjectId(projectId: String, completion: (project: Project?, error: NSError?) -> Void) {
        guard let projectIdInt = Int(projectId) else {
            completion(project: nil, error: NSError.jiramazingErrorWithCode(.InvalidParameter, description: "The project id passed could not be parsed to an integer. All Jira object ids are integers."))
            return
        }

        self.get("/rest/api/2/project/\(projectId)") { (data, error) in
            if let error = error {
                completion(project: nil, error: error)
                return
            }

            if let data = data as? [String: AnyObject] {
                let project = Project(attributes: data)
                completion(project: project, error: nil)
            } else {
                completion(project: nil, error: NSError.jiramazingUnexpectedStructureError())
            }
        }
    }

    // MARK: - Issue
    public func getIssueWithIdOrKey(idOrKey: String, completion: (issue: Issue?, error: NSError?) -> Void) {
        self.get("/rest/api/2/issue/\(idOrKey)", queryParameters: ["expand": "names,editmeta,changelog"]) { (data, error) in
            if let error = error {
                completion(issue: nil, error: error)
                return
            }

            if let data = data as? [String: AnyObject] {
                let issue = Issue(attributes: data)
                completion(issue: issue, error: nil)
            } else {
                completion(issue: nil, error: NSError.jiramazingUnexpectedStructureError())
            }
        }
    }

    // MARK: - Search
    public func searchIssuesWithJQLString(jql: String,
                                          offset: Int = 0,
                                          maxResults: Int = 50,
                                          fields: [String]? = nil,
                                          expand: [String]? = nil,
                                          completion: (issues: [Issue]?, total: Int, error: NSError?) -> Void) {

        var params: [String: AnyObject] = [
            "jql": jql,
            "startAt": offset,
            "maxResults": maxResults
        ]

        if let fields = fields {
            params["fields"] = fields.joinWithSeparator(",")
        }

        if let expand = expand {
            params["expand"] = expand.joinWithSeparator(",")
        }

        self.get("/rest/api/2/search", queryParameters: params) { (data, error) in
            if let error = error {
                completion(issues: nil, total: 0, error: error)
                return
            }

            if let data = data as? [String: AnyObject],
               let total = data["total"] as? Int,
               let issuesAttributes = data["issues"] as? [[String: AnyObject]] {

                let issues = issuesAttributes.map({ (issueAttributes) -> Issue in
                    return Issue(attributes: issueAttributes)
                })

                completion(issues: issues, total: total, error: nil)
                return

            } else {
                completion(issues: nil, total: 0, error: NSError.jiramazingUnexpectedStructureError())
                return
            }
        }
    }

    // MARK: - User
    public func getUserWithUsername(username: String, completion: (user: User?, error: NSError?) -> Void) {
        self.get("/rest/api/2/user", queryParameters: ["username": username, "expand": "groups,applicationRoles"]) { (data, error) in
            if let error = error {
                completion(user: nil, error: error)
                return
            }

            if let data = data as? [String: AnyObject] {
                let user = User(attributes: data)
                completion(user: user, error: nil)
            } else {
                completion(user: nil, error: NSError.jiramazingUnexpectedStructureError())
            }
        }
    }

    public func getUserWithKey(key: String, completion: (user: User?, error: NSError?) -> Void) {
        self.get("/rest/api/2/user", queryParameters: ["key": key, "expand": "groups,applicationRoles"]) { (data, error) in
            if let error = error {
                completion(user: nil, error: error)
                return
            }

            if let data = data as? [String: AnyObject] {
                let user = User(attributes: data)
                completion(user: user, error: nil)
            } else {
                completion(user: nil, error: NSError.jiramazingUnexpectedStructureError())
            }
        }
    }

    // MARK: - HTTP methods
    private func get(path: String,
                     queryParameters: [String: AnyObject]? = nil,
                     authenticationMethod: AuthenticationMethod? = nil,
                     customHeaders: [String: AnyObject]? = nil,
                     completion: (data: AnyObject?, error: NSError?) -> Void) {

        guard let baseUrl = self.baseUrl else {
            completion(data: nil, error: NSError.jiramazingErrorWithCode(.BaseUrlNotSet, description: "Could not complete the request. The base URL was not set."))
            return
        }

        do {
            let request = try NSMutableURLRequest.requestWithHTTPMethod("GET", baseUrl: baseUrl, path: path, queryParameters: queryParameters, customHeaders: customHeaders)

            weak var weakSelf = self
            self.performDataTaskWithRequest(request, authenticationMethod: authenticationMethod ?? self.authenticationMethod, completion: completion)
        } catch let error as NSError {
            completion(data: nil, error: error)
        }
    }

    private func put(path: String,
                     queryParameters: [String: AnyObject]? = nil,
                     bodyInfo: [String: AnyObject],
                     authenticationMethod: AuthenticationMethod?,
                     customHeaders: [String: AnyObject]? = nil,
                     completion: (data: AnyObject?, error: NSError?) -> Void) {

        guard let baseUrl = self.baseUrl else {
            completion(data: nil, error: NSError.jiramazingErrorWithCode(.BaseUrlNotSet, description: "Could not complete the request. The base URL was not set."))
            return
        }

        do {
            let request = try NSMutableURLRequest.requestWithHTTPMethod("GET", baseUrl: baseUrl, path: path, queryParameters: queryParameters, customHeaders: customHeaders)

            if let bodyData = try? NSJSONSerialization.dataWithJSONObject(bodyInfo, options: []) {
                request.HTTPBody = bodyData
            } else {
                completion(data: nil, error: NSError.jiramazingErrorWithCode(.JSONEncodingError, description: "Could not complete the request. The supplied bodyInfo could not be encoded to a JSON object."))
                return
            }

            weak var weakSelf = self
            self.performDataTaskWithRequest(request, authenticationMethod: authenticationMethod ?? self.authenticationMethod, completion: completion)
        } catch let error as NSError {
            completion(data: nil, error: error)
        }
    }

    private func post(path: String,
                      queryParameters: [String: AnyObject]? = nil,
                      bodyInfo: [String: AnyObject],
                      authenticationMethod: AuthenticationMethod?,
                      customHeaders: [String: AnyObject]? = nil,
                      completion: (data: AnyObject?, error: NSError?) -> Void) {

        guard let baseUrl = self.baseUrl else {
            completion(data: nil, error: NSError.jiramazingErrorWithCode(.BaseUrlNotSet, description: "Could not complete the request. The base URL was not set."))
            return
        }

        do {
            let request = try NSMutableURLRequest.requestWithHTTPMethod("GET", baseUrl: baseUrl, path: path, queryParameters: queryParameters, customHeaders: customHeaders)

            if let bodyData = try? NSJSONSerialization.dataWithJSONObject(bodyInfo, options: []) {
                request.HTTPBody = bodyData
            } else {
                completion(data: nil, error: NSError.jiramazingErrorWithCode(.JSONEncodingError, description: "Could not complete the request. The supplied bodyInfo could not be encoded to a JSON object."))
                return
            }

            weak var weakSelf = self
            self.performDataTaskWithRequest(request, authenticationMethod: authenticationMethod ?? self.authenticationMethod, completion: completion)
        } catch let error as NSError {
            completion(data: nil, error: error)
        }
    }

    private func delete(path: String,
                        queryParameters: [String: AnyObject]? = nil,
                        authenticationMethod: AuthenticationMethod?,
                        customHeaders: [String: AnyObject]? = nil,
                        completion: (data: AnyObject?, error: NSError?) -> Void) {

        guard let baseUrl = self.baseUrl else {
            completion(data: nil, error: NSError.jiramazingErrorWithCode(.BaseUrlNotSet, description: "Could not complete the request. The base URL was not set."))
            return
        }

        do {
            let request = try NSMutableURLRequest.requestWithHTTPMethod("GET", baseUrl: baseUrl, path: path, queryParameters: queryParameters, customHeaders: customHeaders)

            weak var weakSelf = self
            self.performDataTaskWithRequest(request, authenticationMethod: authenticationMethod ?? self.authenticationMethod, completion: completion)
        } catch let error as NSError {
            completion(data: nil, error: error)
        }
    }

    private func performDataTaskWithRequest(request: NSMutableURLRequest,
                                            authenticationMethod: AuthenticationMethod?,
                                            completion: (data: AnyObject?, error: NSError?) -> Void) {

        var resolvedAuthMethod = self.authenticationMethod

        if let authenticationMethod = authenticationMethod {
            resolvedAuthMethod = authenticationMethod
        }

        if resolvedAuthMethod == .Basic {
            if self.username.isEmpty || self.password.isEmpty {
                completion(data: nil, error: NSError.jiramazingErrorWithCode(.Unauthenticated, description: "Authentication method is .Basic, but username or password is not set."))
                return
            }

            let authString = String.basicAuthEncodedString(username, password: password)
            request.setValue(authString, forHTTPHeaderField: "Authorization")
        }

        let task = self.urlSession.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                completion(data: nil, error: error)
                return
            } else if let response = response as? NSHTTPURLResponse where response.statusCode >= 400 {
                fatalError("Handling non-fatal HTTP errors not yet supported.")
            } else if let data = data {
                do {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? AnyObject {
                        completion(data: jsonObject, error: nil)
                        return
                    }
                } catch {
                    completion(data: nil, error: NSError.jiramazingErrorWithCode(.MalformedJSONResponse, description: "Unabled to parse the server response because it was malformed."))
                    return
                }
            }
        }

        task.resume()
    }
}

// MARK: - Extensions
private extension NSError {
    class func jiramazingErrorWithCode(code: ErrorCode, description: String) -> NSError {
        return NSError(
            domain: Jiramazing.ErrorDomain,
            code: code.rawValue,
            userInfo: [NSLocalizedDescriptionKey: description]
        )
    }

    class func jiramazingUnexpectedStructureError() -> NSError {
        return NSError.jiramazingErrorWithCode(.UnexpectedResponseStructure, description: "The response was valid JSON, but was of an unexpected structure.")
    }
}

private extension NSMutableURLRequest {
    class func requestWithHTTPMethod(method: String, baseUrl: NSURL, path: String, queryParameters: [String: AnyObject]? = nil, customHeaders: [String: AnyObject]? = nil) throws -> NSMutableURLRequest {
        if let components = NSURLComponents(URL: baseUrl, resolvingAgainstBaseURL: true) {
            components.path = path

            if let queryParameters = queryParameters {
                let queryItemsToAdd = queryParameters.map({ (key, value) -> NSURLQueryItem in
                    return NSURLQueryItem(name: key, value: String(value))
                })

                if components.queryItems == nil {
                    components.queryItems = queryItemsToAdd
                } else {
                    components.queryItems?.appendContentsOf(queryItemsToAdd)
                }
            }

            if let url = components.URL {
                let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: Jiramazing.TimeoutInterval)
                request.HTTPMethod = method

                if let customHeaders = customHeaders {
                    for (key, value) in customHeaders {
                        request.addValue(String(value), forHTTPHeaderField: key)
                    }
                }

                return request

            } else {
                throw NSError.jiramazingErrorWithCode(.MalformedPath, description: "Could not complete the request. The path was malformed.")
            }

        } else {
            throw NSError.jiramazingErrorWithCode(.MalformedBaseUrl, description: "The request's base URL was malformed.")
        }
    }
}
