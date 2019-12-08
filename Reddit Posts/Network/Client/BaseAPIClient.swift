//
//  BaseAPIClient.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import Foundation

class BaseAPIClient {
    
    internal let session: URLSession = URLSession(configuration: .default)
    internal var baseURL: String = ""
    
    internal init() {}
    
    internal func createRequestForURL(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    internal func handleError(response: URLResponse?, error: Error?) {
        // TODO
    }
    
}
