//
//  PhotoModelTests.swift
//  AirLiftCaseStudyTests
//
//  Created by Ammad on 29/08/2021.
//

import XCTest
@testable import AirLiftCaseStudy

class PhotoModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Initialization Tests
    func testPhotoModel_ForInit_ReturnsSuccess() {
        
        // Arrange
        
        let localURL = "www.dummyLocalURL.com"
        let urls = URLS(regular: "www.dummyRegular.com")
        let height = 100
        
        // Act
        
        // sut: System Under Test
        let sut = Photo(id: "123", urls: urls, height: height, localURL: localURL)
        
        // Assert
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.id, "123")
        XCTAssertEqual(sut.urls, urls)
        XCTAssertEqual(sut.height, height)
        XCTAssertEqual(sut.localURL, localURL)
    }
    
    // MARK: - Equatable Tests
    
    func testPhotoModel_ForEquatable_ReturnsSuccess() {
        
        // Arrange
        let localURL = "www.dummyLocalURL.com"
        let urls = URLS(regular: "www.dummyRegular.com")
        let height = 100
        
        // Act
        let photo1 = Photo(id: "123", urls: urls, height: height, localURL: localURL)
        let photo2 = Photo(id: "123", urls: urls, height: height, localURL: localURL)
        
        // Assert
        XCTAssertEqual(photo1, photo2)
    }
}
