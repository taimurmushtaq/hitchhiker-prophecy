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
    var homeController:HomeSceneViewController!
    
    override func setUpWithError() throws {
        navController = HomeSceneConfigurator.configure()
        homeController = navController.viewControllers.first as? HomeSceneViewController
        
        homeController?.beginAppearanceTransition(true, animated: true)
        homeController?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        navController.popToRootViewController(animated: true)
        
        homeController.endAppearanceTransition()
        homeController = nil
        navController = nil
    }
}

extension HomeSceneViewControllerUnitTest {
    func testDidFetchCharactersArray() {
        homeController.didFetchCharacters(viewModel: getViewModel())
        XCTAssertEqual(homeController.charactersArray.count, 3)
        
        let model = homeController.charactersArray.first
        XCTAssertEqual(model?.name, "Avengers")
        XCTAssertEqual(model?.desc, "Avengers: Age of Ultron")
        XCTAssertEqual(model?.imageUrl, "Url")
    }
}

extension HomeSceneViewControllerUnitTest {
    func testConfiguratorMethod() {
        XCTAssertNotNil(homeController.interactor)
        XCTAssertNotNil(homeController.router)
        
        XCTAssertNotNil(homeController.interactor!.worker)
        XCTAssertNotNil(homeController.interactor!.presenter)
        XCTAssertNotNil(homeController.interactor!.presenter.displayView)
        
        XCTAssertNotNil(homeController.router!.viewController)
    }
}

extension HomeSceneViewControllerUnitTest {
    func testNavigation() {
        homeController.setNavigationItems()
        
        XCTAssertNotNil(homeController.navigationItem.rightBarButtonItem)
        XCTAssertEqual(homeController.navigationItem.rightBarButtonItem?.title, "Change Layout")
    }
    
    func testSetupCharacterCollectionView() {
        homeController.setupCharacterCollectionView()
        
        let cell = homeController.characterCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCharacterCollectionViewCell.identifier, for: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(cell)
        XCTAssertNotNil(homeController.characterCollectionView.delegate)
        XCTAssertNotNil(homeController.characterCollectionView.dataSource)
        XCTAssertEqual(homeController.characterCollectionView.backgroundColor, .clear)
    }
}

extension HomeSceneViewControllerUnitTest {
    func testHorizontalLayout() {
        let expectation = self.expectation(description: "Horizontal Layout")
        
        homeController.currentLayout = .list
        homeController.changeLayoutButtonPressed()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5, handler: nil)
     
        XCTAssertEqual(homeController.currentLayout, .peek)
        
        let layout = homeController.characterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        XCTAssertEqual(layout?.scrollDirection, .horizontal)
    }
    
    func testVerticalLayout() {
        let expectation = self.expectation(description: "Vertical Layout")
        
        homeController.currentLayout = .peek
        homeController.changeLayoutButtonPressed()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
     
        XCTAssertEqual(homeController.currentLayout, .list)
        
        let layout = homeController.characterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
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
        XCTAssertEqual(homeController.numberOfSections(in: homeController.characterCollectionView), 1)
    }
    
    func testNumberOfItems() {
        homeController.charactersArray.removeAll()
        XCTAssertEqual(homeController.collectionView(homeController.characterCollectionView, numberOfItemsInSection: 0), 0)
        
        homeController.charactersArray.append(contentsOf: getViewModel())
        XCTAssertEqual(homeController.collectionView(homeController.characterCollectionView, numberOfItemsInSection: 0), 3)
    }
    
    func testLineSpacing() {
        let spacing = homeController.collectionView(homeController.characterCollectionView,
                                                    layout: homeController.characterCollectionView.collectionViewLayout,
                                                    minimumLineSpacingForSectionAt: 0)
        XCTAssertEqual(spacing, HomeSceneConstants.lineSpacing)
    }
    
    func testInterItemSpacing() {
        let spacing = homeController.collectionView(homeController.characterCollectionView,
                                                    layout: homeController.characterCollectionView.collectionViewLayout,
                                                    minimumInteritemSpacingForSectionAt: 0)
        XCTAssertEqual(spacing, HomeSceneConstants.interItemSpacing)
    }
    
    func testVerticalEdgeInset() {
        homeController.currentLayout = .list
        let edgeInset = homeController.collectionView(homeController.characterCollectionView,
                                                    layout: homeController.characterCollectionView.collectionViewLayout,
                                                    insetForSectionAt: 0)
        XCTAssertEqual(edgeInset, .zero)
    }
    
    func testHorizontalEdgeInset() {
        homeController.currentLayout = .peek
        let edgeInset = homeController.collectionView(homeController.characterCollectionView,
                                                    layout: homeController.characterCollectionView.collectionViewLayout,
                                                    insetForSectionAt: 0)
        XCTAssertEqual(edgeInset, HomeSceneConstants.edgeInset)
    }
    
    func testVerticalItemSize() {
        homeController.currentLayout = .list
        let size = homeController.collectionView(homeController.characterCollectionView,
                                                 layout: homeController.characterCollectionView.collectionViewLayout,
                                                 sizeForItemAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(size, HomeSceneConstants.verticalSize)
    }
    
    func testHorizontalItemSize() {
        homeController.currentLayout = .peek
        let size = homeController.collectionView(homeController.characterCollectionView,
                                                 layout: homeController.characterCollectionView.collectionViewLayout,
                                                 sizeForItemAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(size, HomeSceneConstants.horizontalSize)
    }
}
