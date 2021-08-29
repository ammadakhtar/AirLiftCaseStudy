//
//  Photo.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 27/08/2021.
//

import Foundation

struct Photo: Decodable, Equatable {
    let id: String?
    let urls: URLS?
    let height: Int?
    var localURL: String?
    
    /*
     - This init method is to validate unit test for our Photo Property
     */
    
    init(id: String, urls: URLS, height: Int, localURL: String) {
        self.id = id
        self.urls = urls
        self.height = height
        self.localURL = localURL
    }
    
    // MARK: - Equatable Protocol
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
}

struct URLS: Decodable, Equatable {
   
    let regular: String?
    
    /*
     - This init method is to validate unit test
     */
    
    init(regular: String) {
        self.regular = regular
    }
}
