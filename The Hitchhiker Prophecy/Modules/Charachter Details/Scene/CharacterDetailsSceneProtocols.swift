//
//  CharacterDetailsSceneProtocols.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Tarek on 6/15/20.
//  Copyright (c) 2020 SWVL. All rights reserved.
//
//  Looks like you're cooking something intersting 🚀
//

import Foundation

protocol CharacterDetailsSceneDisplayLogic: AnyObject {
    var interactor: CharacterDetailsSceneBusinessLogic? { get }
    
    func didFetchCharacter(viewModel: CharacterDetailsScene.FetchCharacter.ViewModel)
}

protocol CharacterDetailsSceneBusinessLogic: AnyObject {
    func fetchCharacter()
}

protocol CharacterDetailsSceneDataStore: AnyObject {
    var presenter: CharacterDetailsScenePresentationLogic { get }
    var character: Characters.Search.Character { get }
}

protocol CharacterDetailsScenePresentationLogic: AnyObject {
    var displayView: CharacterDetailsSceneDisplayLogic? { get }
    
    func presentCharacter(_ response: CharacterDetailsScene.FetchCharacter.Response)
}
