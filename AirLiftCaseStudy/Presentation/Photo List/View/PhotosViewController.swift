//
//  PhotosViewController.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 28/08/2021.
//

import UIKit

final class PhotosViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - IBOutlets and variables
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: PhotoViewModel
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        return activityIndicator
    }()
    
    // MARK: - Init Methods
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        title = "AirLift Gallery"
        collectionView.register(PhotoCollectionViewCell.self)
        if let layout = collectionView.collectionViewLayout as? WaterFallLayout {
            layout.delegate = self
        }
        activityIndicator.center = collectionView.center
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
    }
    
    private func setupViewModel() {
        
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.viewModel.isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.showAlertClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let message = self.viewModel.alertMessage {
                    self.showAlert(message)
                }
            }
        }
        
        viewModel.reloadCollectionViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            self.viewModel.isLoading = false
        }
        
        viewModel.fetchPhotos()
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Pagination
        let scrolledDistance = scrollView.contentOffset.y + scrollView.frame.height
        let percentage = (scrolledDistance/scrollView.contentSize.height) * 100
        
        // for smooth pagination when 85% content has been scrolled load next page of photos
        if !viewModel.isLoading && percentage > 85 {
            viewModel.fetchPhotos()
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource, WaterFallLayoutDelegate {
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        viewModel.loadImage(for: indexPath) { imageReturned in
            if let image = imageReturned {
                cell.configureCell(image: image)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(viewModel.numberOfItems)
        return viewModel.numberOfItems
    }
    
    // MARK: - WaterFallLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        // since height is returned in 1000's so dividing it by 15 here to get desired height
        // it will still be different for each item as original returned height is different
        // each photo returned
        return viewModel.heightForPhoto(indexPath: indexPath) / 15
    }
}
