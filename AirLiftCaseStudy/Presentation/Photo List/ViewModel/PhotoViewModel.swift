//
//  PhotoViewModel.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 28/08/2021.
//

import UIKit

final class PhotoViewModel {
    
    private var dataRepository: DataRepositoryProtocol
    
    var page = 1
    var offSet = 0
    var photosArray = [Photo]()
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadCollectionViewClosure: (()->())?
    let documentsURL = FileManager.getDocumentsDirectory()
    
    // using FileManager extension here
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
            self.isLoading = false
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    private var cellViewModels: [PhotoCellUIModel] = [PhotoCellUIModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    
    init(dataRepository: DataRepositoryProtocol) {
        self.dataRepository = dataRepository
    }
    
    func fetchPhotos() {
        self.isLoading = true
        dataRepository.fetchPhotos(offSet: offSet, page: page){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                if photos.count > 0 {
                    self.photosArray.append(contentsOf: photos)
                    self.processPhotosToCellModel(photos: self.photosArray)
                    self.offSet = self.offSet + 10
                    self.page = self.page + 1
                } else {
                    // when records are 0 we need to hide activity indicator
                    self.isLoading = false
                }
            case .failure(let error):
                self.processError(error: error)
                self.isLoading = false
            }
        }
    }
    
    var numberOfItems: Int {
        return cellViewModels.count
    }
    
    private func processError(error:Error) {
        self.alertMessage = error.localizedDescription
    }
    
    private func processPhotosToCellModel(photos: [Photo]) {
        self.cellViewModels = photos.map { createCellViewModel(photo: $0) }
    }
    
    private func createCellViewModel(photo: Photo) -> PhotoCellUIModel {
        return PhotoCellUIModel(imageId: photo.id, imageUrl: photo.urls?.regular, imageHeight: photo.height)
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoCellUIModel {
        return cellViewModels[indexPath.row]
    }
    
    func heightForPhoto(indexPath: IndexPath) -> CGFloat {
        return CGFloat(photosArray[indexPath.row].height ?? 200)
    }
    
    func loadImage(for indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) {
        var photo = photosArray[indexPath.row]
        
        // if fileExists it means the image was downloaded and saved to disk
        // so we wont load it from api even if we have internet connection
        // this makes image loading battery and memory efficent
        let fileURL = documentsURL.appendingPathComponent(photo.id ?? "")
        let fileExists = (try? fileURL.checkResourceIsReachable()) ?? false
        
        if fileExists {
            do {
                let imageData = try Data(contentsOf: fileURL)
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(UIImage(data: imageData))
                })
            } catch {
                print("Error loading image : \(error)")
            }
        } else if let url = URL(string: photo.urls?.regular ?? "") {
            
            // the image would be loaded for the first time
            URLSession.shared.dataTask(with: url) { [weak self] (data , response , error ) in
                guard let self = self else { return }
                if error != nil {
                    return
                } else {
                    if let data = data, let image = UIImage(data: data), let id = photo.id {
                        // photo id is unique so we can use it as file name for uniqueness
                        // save the loaded image in document directory for faster load and offline support
                        if let fileURL = self.storeImageWith(fileName: id, image: image) {
                            photo.localURL = "\(fileURL)"
                            self.dataRepository.savePhoto(photo: Photo(id: photo.id ?? "", urls: URLS(regular: photo.urls?.regular ?? ""), height: photo.height ?? 200, localURL: "\(fileURL)"))
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion(image)
                        })
                    }
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
    
    private func storeImageWith(fileName: String, image: UIImage) -> URL? {
        if let data = image.jpegData(compressionQuality: 0.5) {
            let fileURL = documentsURL.appendingPathComponent(fileName)
            do {
                try data.write(to: fileURL, options: .atomic)
                return fileURL
            }
            catch {
                print("Unable to Write Data to Disk (\(error.localizedDescription))")
            }
        }
        return nil
    }
}
