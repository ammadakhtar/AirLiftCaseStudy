//
//  EndPoint.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 28/08/2021.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!.absoluteString.removingPercentEncoding!
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData)
        request.setValue("Client-ID \(AppConfiguration().apiAccessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}

enum PhotosRecord {
    
    case photoLists(page: Int)
}

extension PhotosRecord: Endpoint {
    
    var base: String {
        return AppConfiguration().apiBaseURL
    }
    
    var path: String {
        switch self {
        case .photoLists(let page):
            return "/photos?page=\(page)"
        }
    }
}
