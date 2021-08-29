//
//  PhotoCollectionViewCell.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 28/08/2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, NibLoadableView {
    
    @IBOutlet weak var photoImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 6
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
    
    func configureCell(image: UIImage) {
        self.photoImageView.image = image
    }
}

