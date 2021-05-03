//
//  HomeSceneProtocols.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/12/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

protocol HomeSceneDisplayView: AnyObject {
    var interactor: HomeSceneBusinessLogic? { get }
    var router: HomeSceneRoutingLogic? { get }
    
    func didFetchCharacters(viewModel: [HomeScene.Search.ViewModel])
    func failedToFetchCharacters(error: Error)
}

protocol HomeSceneBusinessLogic: AnyObject {
    var worker: HomeWorkerType { get }
    var presenter: HomeScenePresentationLogic { get }
    
    func fetchCharacters()
}

protocol HomeScenePresentationLogic: AnyObject {
    var displayView: HomeSceneDisplayView? { get }
    
    func presentCharacters(_ response: HomeScene.Search.Response)
}

protocol HomeSceneDataStore: AnyObject {
    var result: Characters.Search.Results? { get }
}

protocol HomeSceneDataPassing: AnyObject {
    var dataStore: HomeSceneDataStore? { get }
}

protocol HomeSceneRoutingLogic: AnyObject {
    var viewController: (HomeSceneDisplayView & UIViewController)? { get }
    
    func routeToCharacterDetailsWithCharacter(at index: Int)
}

protocol HomeWorkerType {
    func getCharacters(_ input: Characters.Search.Input, completion: @escaping (HomeScene.Search.Response) -> Void)
}
