//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by Alexey on 01.05.2023.
//

import XCTest
@testable import ImageFeed

class mockError: Error {}

final class ImageListViewTests: XCTestCase {
    
    func testImageListViewControllerDidLoad() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        _ = viewController.view
        // Then:
        XCTAssertTrue(presenter.viewDidLoad)
    }
    
    func testDateToStringDidChange() {
        // Given:
        let imageService = ImagesListService()
        guard let dateService = imageService.dateService else { return }
        // When:
        let dateString = "2016-05-03T11:00:28-04:00"
        let date = dateService.toDate(dateString)
        let string = dateService.dateToString(date: date)
        // Then:
        XCTAssertEqual(string, "3 мая 2016 г.")
    }
    
    func testPhotosDidDownload() {
        // Given:
        let presenter = ImageListViewPresenter()
        // When:
        presenter.setupObservers()
        // Then:
        XCTAssertNotNil(presenter.photos)
    }
    
    func testTableViewDidUpdateWithImageService() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        let imageService = ImagesServiceStub()
        presenter.imagesListService = imageService
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        _ = viewController.view
        imageService.addPhotos()
        // Then:
        XCTAssertNotNil(imageService.photos)
    }
    
    func testSetLikeImage() {
        // Given:
        let presenter = ImageListViewPresenter()
        // When:
        let image = presenter.setLikeButtonImage(isLiked: true)
        // Then:
        XCTAssertEqual(image, UIImage(named: "Active"))
    }
    
    func testTableViewDidInit() {
        // Given:
        let viewController = ImageListViewController()
        let tableView = viewController.imageListView.tableView
        // When:
        _ = viewController.view
        // Then:
        XCTAssertNotNil(tableView)
    }
    
    func testImageListIsTableViewDataSource() {
        // Given:
        let viewController = ImageListViewController()
        let tableView = viewController.imageListView.tableView
        // When:
        _ = viewController.view
        // Then:
        XCTAssertTrue(tableView.dataSource is ImageListViewController)
    }
    
    func testImageListIsTableViewDelegate() {
        // Given:
        let viewController = ImageListViewController()
        let tableView = viewController.imageListView.tableView
        // When:
        _ = viewController.view
        // Then:
        XCTAssertTrue(tableView.delegate is ImageListViewController)
    }
    
    func testTableViewReturnDefaultCountOfCells() { 
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        viewController.presenter = presenter
        let tableView = UITableView()
        // When:
        presenter.fetchPhotosFromData()
        let result = viewController.tableView(tableView, numberOfRowsInSection: presenter.photos.count)
        //Then:
        XCTAssertNotEqual(result, 0)
    }
    
    func testTableViewReturnConfiguredCountOfCells() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        let tableView = UITableView()
        // When:
        let result = viewController.tableView(tableView, numberOfRowsInSection: presenter.photos.count)
        //Then:
        XCTAssertEqual(result, 0)
    }
    
    func testTableViewHeightWithoutPresenter() {
        // Given:
        let viewController = ImageListViewController()
        let tableView = UITableView()
        // When:
        let result = viewController.tableView(tableView, heightForRowAt: .init())
        
        XCTAssertEqual(result, 100)
    }
    
    func testTableViewHeightWithPresenter() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        viewController.presenter = presenter
        let tableView = UITableView()
        // When:
        presenter.fetchPhotosFromData()
        let result = viewController.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        // Then:
        XCTAssertNotEqual(result, 100)
    }
    
    func testTableViewHeightDidSettedInHash() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        viewController.presenter = presenter
        let tableView = UITableView()
        // When:
        presenter.fetchPhotosFromData()
        let heightOfMember = viewController.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        viewController.heightsOfRows["id"] = heightOfMember
        let result = viewController.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        // Then:
        XCTAssertEqual(result, viewController.heightsOfRows["id"])
    }
    
    func testTableViewCellDidDefault() {
        // Given:
        let viewController = ImageListViewController()
        let tableView = UITableView()
        let imageListCell = ImagesListCell()
        imageListCell.delegate = viewController
        // When:
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        let cell = viewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        // Then:
        XCTAssertEqual(cell.reuseIdentifier, "")
    }
    
    func testTableViewCellDidConfigured() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        viewController.presenter = presenter
        let tableView = UITableView()
        let imageListCell = ImagesListCell()
        imageListCell.delegate = viewController
        // When:
        _ = viewController.view
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        presenter.fetchPhotosFromData()
        let cell = viewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        // Then:
        XCTAssertEqual(cell.reuseIdentifier,ImagesListCell.reuseIdentifier)
    }
    
    func testTableViewCellDidCongigured() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        viewController.presenter = presenter
        let tableView = UITableView()
        let imageListCell = ImagesListCell()
        imageListCell.delegate = viewController
        // When:
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        presenter.fetchPhotosFromData()
        let cell = viewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        // Then:
        XCTAssertEqual(cell.reuseIdentifier,ImagesListCell.reuseIdentifier)
    }
    
    func testImageListCellDidTapLikeWithoutPresenter() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        let imageListCell = ImagesListCell()
        imageListCell.delegate = viewController
        // When:
        _ = viewController.view
        presenter.fetchPhotosFromData()
        let photo = presenter.photos[0]
        viewController.imageListCellDidTapLike(imageListCell)
        // Then:
        XCTAssertEqual(photo.isLiked, presenter.photos[0].isLiked)
    }
    
    func testSwithToSingleViewController() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenter()
        viewController.presenter = presenter
        let singleViewController = SingleViewControllerSpy()
        let presenterSpy = ImageListViewPresenterSpy()
        // When:
        presenterSpy.fetchPhotosFromData()
        presenter.photos = presenterSpy.photos
        viewController.switchToSingleViewController(sender: IndexPath(row: 0, section: 0), viewController: singleViewController)
        // Then:
        XCTAssertTrue(singleViewController.didLoad)
    }
    
    func testTableViewWillDisplay() {
        // Given:
        let viewController = ImageListViewController()
        let presenter = ImageListViewPresenterSpy()
        let imageService = ImagesServiceStub()
        presenter.imagesListService = imageService
        viewController.presenter = presenter
        let mockTableView = UITableView()
        let mockCellell = UITableViewCell()
        // When
        presenter.fetchPhotosFromData()
        imageService.fetchPhotosNextPage("12345")
        viewController.tableView(mockTableView, willDisplay: mockCellell, forRowAt: IndexPath(row: 0, section: 0))
        // Then
        XCTAssertTrue(imageService.photosPageDidFetched)
    }
}
