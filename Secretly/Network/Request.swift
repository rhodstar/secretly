//
//  RequestBuilder.swift
//  Secretly
//
//  Created by LuisE on 2/17/20.
//  Copyright © 2020 3zcurdia. All rights reserved.
//

import Foundation

struct Request {
    enum ContentMode {
        case json

        func accept() -> String {
            switch self {
            case .json:
                return "application/json"
            }
        }

        func contentType() -> String {
            switch self {
            case .json:
                return "application/json"
            }
        }
    }
    private let urlComponents: URLComponents
    public var scheme: String = "https"
    public var method: String = "get"
    public var path: String = "/"
    public var body: Data?
    public var headers: [String: String]?
    public var contentMode: ContentMode = .json

    init(baseUrl: String) {
        self.urlComponents = URLComponents(string: baseUrl)!
    }

    var urlRequest: URLRequest? {
        get {
            return build()
        }
    }

    func url() -> URL? {
        var comps = self.urlComponents
        comps.scheme = scheme
        comps.path = path
        return comps.url
    }

    private func build() -> URLRequest? {
        guard let url = url() else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.httpBody = body
        req.addValue(contentMode.accept(), forHTTPHeaderField: "Accept")
        req.addValue(contentMode.contentType(), forHTTPHeaderField: "Content-Type")
        if let headers = self.headers {
            for (key, value) in headers {
                req.addValue(value, forHTTPHeaderField: key)
            }
        }
        return req
    }
}
