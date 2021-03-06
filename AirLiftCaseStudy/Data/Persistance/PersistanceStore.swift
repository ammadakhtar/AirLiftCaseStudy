//
//  PersistanceStore.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 27/08/2021.
//

import Foundation

import CoreData

protocol PersistanceStore {
    func savePhoto(photo: Photo)
    func loadPhotos(offSet: Int) -> [Photo]?
}

struct PhotoPersistanceStore: PersistanceStore {
    
    let context = PersistentStorage.shared.context
    
    func savePhoto(photo: Photo) {
        
        // cd acronym here means core data
        // performBackgroundTask will ensure a designated queu for context since coredata
        // is not thread safe. This ensure core data concurrency
        
        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            let cdPhoto = CDPhoto(context: privateManagedContext)
            cdPhoto.photoId = photo.id
            cdPhoto.imageURL = photo.urls?.regular
            cdPhoto.height = Int32(photo.height ?? 200)
            cdPhoto.localURL = photo.localURL
            
            if privateManagedContext.hasChanges {
                try? privateManagedContext.save()
            }
        }
    }
    
    func loadPhotos(offSet: Int) -> [Photo]? {
        var photos: [Photo]? = nil
        // performAndWait would ensure the thread for the context since we can call loadPhotos from any thread
        // this ensure concurrency and thread safety of the context on main thread
        context.performAndWait {
            let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDPhoto.self, offSet: offSet)
            photos = result?.map ({ cdPhoto in
                cdPhoto.convertToPhoto()
            })
        }
        return photos
    }
}
