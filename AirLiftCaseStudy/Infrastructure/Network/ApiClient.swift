//
//  ApiClient.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 28/08/2021.
//

import Foundation

class APIClient: APIClientProtocol {
    
    func getPhotos(from type: PhotosRecord, completion: @escaping (Result<[Photo], APIError>) -> Void) {
        fetchInfo (type, decode: { json -> [Photo]? in
            guard let result = json as? [Photo] else { return  nil }
            return result
        }, complete: completion)
    }
}
