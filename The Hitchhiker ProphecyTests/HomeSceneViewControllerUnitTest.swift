//
//  HomeSceneViewControllerUnitTest.swift
//  The Hitchhiker ProphecyTests
//
//  Created by Taimur Mushtaq on 06/05/2021.
//  Copyright © 2021 SWVL. All rights reserved.
//

import XCTest

class HomeSceneViewControllerUnitTest: XCTestCase {
    var navController:UINavigationController!
    var sut:HomeSceneViewController!
    
    override func setUpWithError() throws {
        navController = HomeSceneConfigurator.configure()
        sut = navController.viewControllers.first as? HomeSceneViewController
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
    }

    override func tearDownWithError() throws {
        sut = nil
        navController = nil
    }
}

extension HomeSceneViewControllerUnitTest {
    func testConfiguratorMethod() {
        XCTAssertNotNil(sut.interactor)
        XCTAssertNotNil(sut.router)
        
        XCTAssertNotNil(sut.interactor!.worker)
        XCTAssertNotNil(sut.interactor!.presenter)
        XCTAssertNotNil(sut.interactor!.presenter.displayView)
        
        XCTAssertNotNil(sut.router!.viewController)
    }
}

extension HomeSceneViewControllerUnitTest {
    func testDidFetchCharactersArray() {
        sut.didFetchCharacters(viewModel: getViewModel())
        XCTAssertEqual(sut.charactersArray.count, 3)
        
        let model = sut.charactersArray.first
        XCTAssertEqual(model?.name, "Avengers")
        XCTAssertEqual(model?.desc, "Avengers: Age of Ultron")
        XCTAssertEqual(model?.imageUrl, "Url")
    }
}

extension HomeSceneViewControllerUnitTest {
    func testNavigation() {
        sut.setNavigationItems()
        
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.title, "Change Layout")
    }
    
    func testSetupCharacterCollectionView() {
        sut.setupCharacterCollectionView()
        
        let cell = sut.characterCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCharacterCollectionViewCell.identifier, for: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(cell)
        XCTAssertNotNil(sut.characterCollectionView.delegate)
        XCTAssertNotNil(sut.characterCollectionView.dataSource)
        XCTAssertEqual(sut.characterCollectionView.backgroundColor, .clear)
    }
}

extension HomeSceneViewControllerUnitTest {
    func testHorizontalLayout() {
        let expectation = self.expectation(description: "Horizontal Layout")
        
        sut.currentLayout = .list
        sut.changeLayoutButtonPressed()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5, handler: nil)
     
        XCTAssertEqual(sut.currentLayout, .peek)
        
        let layout = sut.characterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        XCTAssertEqual(layout?.scrollDirection, .horizontal)
    }
    
    func testVerticalLayout() {
        let expectation = self.expectation(description: "Vertical Layout")
        
        sut.currentLayout = .peek
        sut.changeLayoutButtonPressed()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
     
        XCTAssertEqual(sut.currentLayout, .list)
        
        let layout = sut.characterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        XCTAssertEqual(layout?.scrollDirection, .vertical)
    }
}

extension HomeSceneViewControllerUnitTest {
    func getViewModel() -> [HomeScene.Search.ViewModel]{
        let viewModel = HomeScene.Search.ViewModel(name: "Avengers",
                                                   desc: "Avengers: Age of Ultron",
                                                   imageUrl: "Url",
                                                   comics: "",
                                                   series: "",
                                                   stories: "",
                                                   events: "")
        return [viewModel, viewModel, viewModel]
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(sut.numberOfSections(in: sut.characterCollectionView), 1)
    }
    
    func testNumberOfItems() {
        sut.charactersArray.removeAll()
        XCTAssertEqual(sut.collectionView(sut.characterCollectionView, numberOfItemsInSection: 0), 0)
        
        sut.charactersArray.append(contentsOf: getViewModel())
        XCTAssertEqual(sut.collectionView(sut.characterCollectionView, numberOfItemsInSection: 0), 3)
    }
    
    func testLineSpacing() {
        let spacing = sut.collectionView(sut.characterCollectionView,
                                                    layout: sut.characterCollectionView.collectionViewLayout,
                                                    minimumLineSpacingForSectionAt: 0)
        XCTAssertEqual(spacing, HomeSceneConstants.lineSpacing)
    }
    
    func testInterItemSpacing() {
        let spacing = sut.collectionView(sut.characterCollectionView,
                                                    layout: sut.characterCollectionView.collectionViewLayout,
                                                    minimumInteritemSpacingForSectionAt: 0)
        XCTAssertEqual(spacing, HomeSceneConstants.interItemSpacing)
    }
    
    func testVerticalEdgeInset() {
        sut.currentLayout = .list
        let edgeInset = sut.collectionView(sut.characterCollectionView,
                                                    layout: sut.characterCollectionView.collectionViewLayout,
                                                    insetForSectionAt: 0)
        XCTAssertEqual(edgeInset, .zero)
    }
    
    func testHorizontalEdgeInset() {
        sut.currentLayout = .peek
        let edgeInset = sut.collectionView(sut.characterCollectionView,
                                                    layout: sut.characterCollectionView.collectionViewLayout,
                                                    insetForSectionAt: 0)
        XCTAssertEqual(edgeInset, HomeSceneConstants.edgeInset)
    }
    
    func testVerticalItemSize() {
        sut.currentLayout = .list
        let size = sut.collectionView(sut.characterCollectionView,
                                                 layout: sut.characterCollectionView.collectionViewLayout,
                                                 sizeForItemAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(size, HomeSceneConstants.verticalSize)
    }
    
    func testHorizontalItemSize() {
        sut.currentLayout = .peek
        let size = sut.collectionView(sut.characterCollectionView,
                                                 layout: sut.characterCollectionView.collectionViewLayout,
                                                 sizeForItemAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(size, HomeSceneConstants.horizontalSize)
    }
}
