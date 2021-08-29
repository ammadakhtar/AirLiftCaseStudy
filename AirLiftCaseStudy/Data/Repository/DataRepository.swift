//
//  DataRepository.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 27/08/2021.
//

import Foundation

protocol DataRepositoryProtocol {
    func fetchPhotos(offSet: Int, page: Int, complete completion: @escaping (Result<[Photo], Error>) -> Void)
    func savePhoto(photo: Photo)
}

final class DataRepository: DataRepositoryProtocol {
    
    private let persistanceStore: PersistanceStore
    private let apiClient: APIClient
    
    init(persistanceStore: PersistanceStore, apiClient: APIClient) {
        self.persistanceStore = persistanceStore
        self.apiClient = apiClient
    }
    
    // write transaction in coredata
    
    func savePhoto(photo: Photo) {
        persistanceStore.savePhoto(photo: photo)
    }
    
    // read from coredata
    private func loadFromDB(offSet: Int, complete completion: @escaping (Result<[Photo], Error>) -> Void) {
        let photos = persistanceStore.loadPhotos(offSet: offSet)
        completion(.success(photos ?? []))
    }
    
    func fetchPhotos(offSet: Int, page: Int, complete completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        if !Reachability.isConnectedToNetwork() {
            // incase of no internet load from dataBase
            loadFromDB(offSet: offSet) { result in
                completion(.success( try! result.get())
                )
            }
        } else {
            // incase of internet
            apiClient.getPhotos(from: .photoLists(page: page)) { result in
                switch result {
                // success
                case .success(let photos):
                    completion(.success(photos))
                // failure
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
