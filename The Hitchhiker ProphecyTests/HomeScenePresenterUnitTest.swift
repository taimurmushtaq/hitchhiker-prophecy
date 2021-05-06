//
//  HomeScenePresenterUnitTest.swift
//  The Hitchhiker ProphecyTests
//
//  Created by Taimur Mushtaq on 07/05/2021.
//  Copyright © 2021 SWVL. All rights reserved.
//

import XCTest

class HomeScenePresenterUnitTest: XCTestCase {
    
    var displayView: HomeSceneViewController!
    var presenter: HomeScenePresneter!
    
    override func setUpWithError() throws {
        displayView = HomeSceneViewController()
        displayView.beginAppearanceTransition(true, animated: false)
        displayView.endAppearanceTransition()
        
        presenter = HomeScenePresneter(displayView: displayView)
    }
    
    override func tearDownWithError() throws {
        displayView = nil
        presenter = nil
    }
}

extension HomeScenePresenterUnitTest {
    func getOutputData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "response", ofType: "json") {
            return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        }
        
        return nil
    }
    
    func getCharacters() -> HomeScene.Search.Response {
        if let data = getOutputData() {
            if let output = try? JSONDecoder().decode(Characters.Search.Output.self, from: data) {
                return .success(output)
            } else {
                return .failure(NetworkError.cannotParseResponse)
            }
        }
        
        return .failure(NetworkError.unknown)
    }
}

extension HomeScenePresenterUnitTest {
    func testSuccussPresentCharacters() {
        presenter.presentCharacters(getCharacters())
        
        XCTAssertGreaterThan(displayView.charactersArray.count, 0)
    }
    
    func testFailurePresentCharacters() {
        presenter.presentCharacters(.failure(.unknown))
        
        XCTAssertEqual(displayView.charactersArray.count, 0)
    }
}
