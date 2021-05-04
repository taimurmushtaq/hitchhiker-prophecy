//
//  HomeScenePresenter.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/13/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation

class HomeScenePresneter: HomeScenePresentationLogic {
    weak var displayView: HomeSceneDisplayView?
    
    init(displayView: HomeSceneDisplayView) {
        self.displayView = displayView
    }
    
    func presentCharacters(_ response: HomeScene.Search.Response) {
        switch response {
        case .success(let output):
            let results = output.data.results
            
            var viewModel = [HomeScene.Search.ViewModel]()
            
            results.forEach({ character in
                let imageUrl = character.thumbnail.path + character.thumbnail.thumbnailExtension
                
                let model = HomeScene.Search.ViewModel(name: character.name,
                                                       desc: character.resultDescription,
                                                       imageUrl: imageUrl,
                                                       comics: "",
                                                       series: "",
                                                       stories: "",
                                                       events: "")
                viewModel.append(model)
            })
            
            displayView?.didFetchCharacters(viewModel: viewModel)
            
        case .failure(let error):
            displayView?.failedToFetchCharacters(error: error)
        }
    }
}
