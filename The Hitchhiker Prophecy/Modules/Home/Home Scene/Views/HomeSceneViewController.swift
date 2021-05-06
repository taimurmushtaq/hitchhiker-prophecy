//
//  HomeSceneViewController.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

struct HomeSceneConstants {
    static let interItemSpacing = CGFloat(16)
    static let lineSpacing = CGFloat(8)
    static let edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    static let verticalSize = CGSize(width: UIScreen.main.bounds.width - 16*2, height: UIScreen.main.bounds.width * 0.5)
    static let horizontalSize = CGSize(width: UIScreen.main.bounds.width - 20*2, height: UIScreen.main.bounds.height * 0.75)
}

class HomeSceneViewController: UIViewController {
    var interactor: HomeSceneBusinessLogic?
    var router: HomeSceneRoutingLogic?
    var charactersArray = [HomeScene.Search.ViewModel]()
    
    var currentLayout = HomeScene.LayoutType.list
    
    // MARK: - Outlets
    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
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
    func setNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Change Layout", style: .plain, target: self, action: #selector(changeLayoutButtonPressed))
    }
    func setupCharacterCollectionView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: HomeCharacterCollectionViewCell.identifier, bundle: bundle)
        
        characterCollectionView.register(nib, forCellWithReuseIdentifier: HomeCharacterCollectionViewCell.identifier)
        
        characterCollectionView.backgroundColor = .clear
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
    }
}

// MARK: - IBActions
extension HomeSceneViewController {
    @objc func changeLayoutButtonPressed() {
        let layout = UICollectionViewFlowLayout()
        
        if currentLayout == .list {
            currentLayout = .peek
            layout.scrollDirection = .horizontal
        } else {
            currentLayout = .list
            layout.scrollDirection = .vertical
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState) { [self] in
            characterCollectionView.collectionViewLayout = layout
        } completion: { [self] onComplete in
            characterCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return HomeSceneConstants.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return HomeSceneConstants.interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return currentLayout == .list ? .zero : HomeSceneConstants.edgeInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return currentLayout == .list ? HomeSceneConstants.verticalSize : HomeSceneConstants.horizontalSize
    }
}

