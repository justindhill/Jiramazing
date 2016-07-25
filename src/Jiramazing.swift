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
    case MalformedBaseUrl
    case MalformedPath
    case MalformedJSONResponse
    case JSONEncodingError
}

@objc public class Jiramazing: NSObject, NSURLSessionDelegate {
    public private(set) var authenticated: Bool = false
    private var urlSession: NSURLSession!

    private static let TimeoutInterval: NSTimeInterval = 60

    public var authenticationMethod: AuthenticationMethod = .Basic
    public var username: String?
    public var password: String?
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

    public func validateCredentials(username: String, password: String, completion: (success: Bool) -> Void) {
        if let authorizationHeader = String.basicAuthEncodedString(username, password: password) {
            self.get("/rest/auth/1/session", authenticationMethod: .None, customHeaders:["Authorization": authorizationHeader], completion: { (responseJSONObject, error) in
                completion(success: error == nil)
            })
        } else {
            completion(success: false)
        }
    }

    private func get(path: String,
                     queryParameters: [String: AnyObject]? = nil,
                     authenticationMethod: AuthenticationMethod? = nil,
                     customHeaders: [String: AnyObject]? = nil,
                     completion: (data: [String: AnyObject]?, error: NSError?) -> Void) {

        guard let baseUrl = self.baseUrl else {
            completion(data: nil, error: NSError.jiramazingErrorWithCode(.BaseUrlNotSet, description: "Could not complete the request. The base URL was not set."))
            return
        }

        do {
            let request = try NSMutableURLRequest.requestWithHTTPMethod("GET", baseUrl: baseUrl, path: path, queryParameters: queryParameters, customHeaders: customHeaders)

            weak var weakSelf = self
            self.performDataTaskWithRequest(request, authenticationMethod: authenticationMethod ?? self.authenticationMethod, completion: { (responseJSONObject, error) in
                weakSelf?.handleResponseWithData(responseJSONObject, error: error, completion: completion)
            })
        } catch let error as NSError {
            completion(data: nil, error: error)
        }
    }

    private func put(path: String,
                     queryParameters: [String: AnyObject]? = nil,
                     bodyInfo: [String: AnyObject],
                     authenticationMethod: AuthenticationMethod?,
                     customHeaders: [String: AnyObject]? = nil,
                     completion: (data: [String: AnyObject]?, error: NSError?) -> Void) {

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
            self.performDataTaskWithRequest(request, authenticationMethod: authenticationMethod ?? self.authenticationMethod, completion: { (responseJSONObject, error) in
                weakSelf?.handleResponseWithData(responseJSONObject, error: error, completion: completion)
            })
        } catch let error as NSError {
            completion(data: nil, error: error)
        }
    }

    private func post(path: String,
                      queryParameters: [String: AnyObject]? = nil,
                      bodyInfo: [String: AnyObject],
                      authenticationMethod: AuthenticationMethod?,
                      customHeaders: [String: AnyObject]? = nil,
                      completion: (data: [String: AnyObject]?, error: NSError?) -> Void) {

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
            self.performDataTaskWithRequest(request, authenticationMethod: authenticationMethod ?? self.authenticationMethod, completion: { (responseJSONObject, error) in
                weakSelf?.handleResponseWithData(responseJSONObject, error: error, completion: completion)
            })
        } catch let error as NSError {
            completion(data: nil, error: error)
        }
    }

    private func delete(path: String,
                        queryParameters: [String: AnyObject]? = nil,
                        authenticationMethod: AuthenticationMethod?,
                        customHeaders: [String: AnyObject]? = nil,
                        completion: (data: [String: AnyObject]?, error: NSError?) -> Void) {

        guard let baseUrl = self.baseUrl else {
            completion(data: nil, error: NSError.jiramazingErrorWithCode(.BaseUrlNotSet, description: "Could not complete the request. The base URL was not set."))
            return
        }

        do {
            let request = try NSMutableURLRequest.requestWithHTTPMethod("GET", baseUrl: baseUrl, path: path, queryParameters: queryParameters, customHeaders: customHeaders)

            weak var weakSelf = self
            self.performDataTaskWithRequest(request, authenticationMethod: authenticationMethod ?? self.authenticationMethod, completion: { (responseJSONObject, error) in
                weakSelf?.handleResponseWithData(responseJSONObject, error: error, completion: completion)
            })
        } catch let error as NSError {
            completion(data: nil, error: error)
        }
    }

    private func handleResponseWithData(responseJSONObject: [String: AnyObject]?, error: NSError?, completion: (data: [String: AnyObject]?, error: NSError?) -> Void) {

    }

    private func performDataTaskWithRequest(request: NSMutableURLRequest,
                                            authenticationMethod: AuthenticationMethod?,
                                            completion: (data: [String: AnyObject]?, error: NSError?) -> Void) {

        var resolvedAuthMethod = self.authenticationMethod

        if let authenticationMethod = authenticationMethod {
            resolvedAuthMethod = authenticationMethod
        }

        if resolvedAuthMethod == .Basic {
            guard let username = self.username, let password = self.password else {
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
            } else if let response = response as? NSHTTPURLResponse {
                fatalError("Handling non-fatal HTTP errors not yet supported.")
            } else if let data = data {
                do {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
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

private extension NSError {
    class func jiramazingErrorWithCode(code: ErrorCode, description: String) -> NSError {
        return NSError(
            domain: Jiramazing.ErrorDomain,
            code: code.rawValue,
            userInfo: [NSLocalizedDescriptionKey: description]
        )
    }
}

private extension NSMutableURLRequest {
    class func requestWithHTTPMethod(method: String, baseUrl: NSURL, path: String, queryParameters: [String: AnyObject]? = nil, customHeaders: [String: AnyObject]? = nil) throws -> NSMutableURLRequest {
        if let components = NSURLComponents(URL: baseUrl, resolvingAgainstBaseURL: true) {
            components.path = path

            if let queryParameters = queryParameters {
                components.queryItems?.appendContentsOf(queryParameters.map({ (key, value) -> NSURLQueryItem in
                    return NSURLQueryItem(name: key, value: String(value))
                }))
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
