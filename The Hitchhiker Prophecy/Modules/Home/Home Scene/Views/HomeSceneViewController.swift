//
//  HomeSceneViewController.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

class HomeSceneViewController: UIViewController {
    var interactor: HomeSceneBusinessLogic?
    var router: HomeSceneRoutingLogic?
    var charactersArray = [HomeScene.Search.ViewModel]()
    
    var currentLayout = HomeScene.LayoutType.list
    
    // MARK: - Outlets
    @IBOutlet private weak var characterCollectionView: UICollectionView!
    @IBOutlet private weak var changeLayoutButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCharacterCollectionView()
        interactor?.fetchCharacters()
    }
}

// MARK: - HomeSceneDisplayView
extension HomeSceneViewController: HomeSceneDisplayView {
    func didFetchCharacters(viewModel: [HomeScene.Search.ViewModel]) {
        charactersArray = viewModel
        characterCollectionView.reloadData()
    }
    
    func failedToFetchCharacters(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [self ]action in
            interactor?.fetchCharacters()
        }))
        alert.show(self, sender: nil)
    }
}

// MARK: - Helper Methods
extension HomeSceneViewController {
    func setupCharacterCollectionView() {
        let nib = UINib(nibName: HomeCharacterCollectionViewCell.identifier, bundle: .main)
        
        characterCollectionView.register(nib, forCellWithReuseIdentifier: HomeCharacterCollectionViewCell.identifier)
        
        characterCollectionView.backgroundColor = .clear
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        characterCollectionView.reloadData()
    }
    
    func getCollectionViewFlowLayout() -> UICollectionViewFlowLayout? {
        return characterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
}

// MARK: - IBActions
extension HomeSceneViewController {
    @IBAction func changeLayoutButtonPressed() {
        UIView.animate(withDuration: 0.5) { [self] in
            if let layout = getCollectionViewFlowLayout() {
                if currentLayout == .list {
                    currentLayout = .peek
                    layout.scrollDirection = .horizontal
                } else {
                    currentLayout = .list
                    layout.scrollDirection = .vertical
                }
            }
        } completion: { [self] onComplete in
            characterCollectionView.reloadData()
            characterCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - Collectionview delegate and datasource
extension HomeSceneViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCharacterCollectionViewCell.identifier, for: indexPath) as! HomeCharacterCollectionViewCell
        cell.configure(with: charactersArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToCharacterDetailsWithCharacter(at: indexPath.row)
    }
}

