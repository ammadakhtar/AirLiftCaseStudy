//
//  MockDataRepository.swift
//  AirLiftCaseStudyTests
//
//  Created by Ammad on 29/08/2021.
//

import Foundation
@testable import AirLiftCaseStudy

class MockDataRepository {
    
    var shouldReturnError = false
    var isFetchPhotoCalled = false
    var fetchedPhotos = [Photo]()
    var completeClosure: ((Result<[Photo], Error>) -> ())!
    
    convenience init() {
        self.init(false)
    }
    
    init(_ shouldReturnError:Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    func fetchSuccess() {
        completeClosure(.success(fetchedPhotos))
    }
    
    func fetchFail(error: Error) {
        completeClosure(.failure(error))
    }
    
    func reset(){
        shouldReturnError = false
        isFetchPhotoCalled = false
    }
}

extension MockDataRepository: DataRepositoryProtocol {

    func savePhoto(photo: Photo) {}
    
    func fetchPhotos(offSet: Int, page: Int, complete completionHandler: @escaping (Result<[Photo], Error>) -> Void) {
        isFetchPhotoCalled = true
        completeClosure = completionHandler
    }
}

class MockDataGenerator {
    func mockPhotosData() -> [Photo] {
        let path = Bundle.main.path(forResource: "photo", ofType: "json")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let photos = try decoder.decode([Photo].self, from: data!)
            return photos
        } catch let err {
            print(err)
        }
       return []
    }
}
