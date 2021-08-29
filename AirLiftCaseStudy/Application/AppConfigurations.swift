//
//  AppConfigurations.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 27/08/2021.
//

import Foundation

final class AppConfiguration {
    // BASE URL
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("BaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    // SECRET KEY
    lazy var appSecretKey: String = {
        guard let secretKey = Bundle.main.object(forInfoDictionaryKey: "ApiSecretKey") as? String else {
            fatalError("SecretKey must not be empty in plist")
        }
        return secretKey
    }()
    // ACCESS KEY
    lazy var apiAccessKey: String = {
        guard let accessKey = Bundle.main.object(forInfoDictionaryKey: "ApiAccessKey") as? String else {
            fatalError("AccessKey must not be empty in plist")
        }
        return accessKey
    }()
}
