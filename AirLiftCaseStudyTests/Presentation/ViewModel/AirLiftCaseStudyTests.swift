//
//  AirLiftCaseStudyTests.swift
//  AirLiftCaseStudyTests
//
//  Created by Ammad on 27/08/2021.
//

import XCTest
@testable import AirLiftCaseStudy

class AirLiftCaseStudyTests: XCTestCase {
    var sut: PhotoViewModel!
    var mockDataRepository: MockDataRepository!
    
    override func setUp() {
        super.setUp()
        mockDataRepository = MockDataRepository()
        sut = PhotoViewModel(dataRepository: mockDataRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockDataRepository = nil
        super.tearDown()
    }
    
    func test_FetchPhotos_FromDataRepository_Succeeds() {
        
        // Arrange
        mockDataRepository.fetchedPhotos = [Photo]()
        
        // Act
        sut.fetchPhotos()
        
        // Assert
        XCTAssert(mockDataRepository.isFetchPhotoCalled)
    }
    
    func test_LoadingWhileFetching_Suceeds() {
        
        // Arrange
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
        }
        
        // Act
        sut.fetchPhotos()
        
        // Assert
        XCTAssertTrue(loadingStatus)
        
        // When finished fetching
        mockDataRepository!.fetchSuccess()
        XCTAssertFalse(loadingStatus)
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_CreateCellViewModel_Succeeds() {
        generateMockData()
        
        // Arrange
        let expect = XCTestExpectation(description: "reload closure triggered")
        var photos = [Photo]()
        
        // Act
        
        sut.reloadCollectionViewClosure = { [weak self] () in
            expect.fulfill()
            photos = self?.sut.photosArray ?? []
        }
        
        // Assert
        sut.fetchPhotos()
        mockDataRepository.fetchSuccess()
        
        // Number of cell view model is equal to the number of messages
        XCTAssertEqual(sut.numberOfItems, photos.count)
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
    }
}

//MARK: - State control

extension AirLiftCaseStudyTests {
    private func generateMockData() {
        mockDataRepository.fetchedPhotos = MockDataGenerator().mockPhotosData()
        sut.fetchPhotos()
        mockDataRepository.fetchSuccess()
    }
}
