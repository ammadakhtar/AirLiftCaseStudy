//
//  CDPhoto+CoreDataProperties.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 27/08/2021.
//
//

import Foundation
import CoreData


extension CDPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPhoto> {
        return NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
    }

    @NSManaged public var localURL: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var photoId: String?
    @NSManaged public var height: Int32

}

extension CDPhoto : Identifiable {
    func convertToPhoto() -> Photo {
        return Photo(id: self.photoId ?? "", urls: URLS(regular: imageURL ?? ""), height: Int(self.height), localURL: localURL ?? "")
    }
}
