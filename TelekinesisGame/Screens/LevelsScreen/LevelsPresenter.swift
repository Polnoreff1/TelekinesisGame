//
//  LevelsPresenter.swift
//  Maria-Casino
//
//  Created by 1234 on 29.03.2023.
//
//

import UIKit

protocol ILevelsPresenter {
    func viewDidLoad()
    func openGameLevel(with number: Int, gameType: LevelType)
    var viewModel: LevelsViewModel? { get }
}

final class LevelsPresenter: ILevelsPresenter {
    
    weak var view: ILevelsViewController?
    private let viewModelFactory: ILevelsViewModelFactory
    private let router: ILevelsRouter
    
    // MARK: - Initialization
    
    init(
        viewModelFactory: ILevelsViewModelFactory,
        router: ILevelsRouter
    ) {
        self.viewModelFactory = viewModelFactory
        self.router = router
    }
    
    // MARK: - ILevelsPresenter
    
    var viewModel: LevelsViewModel?
    
    func viewDidLoad() {
        let createdViewModel = viewModelFactory.makeViewModel()
        viewModel = createdViewModel
        view?.setup(with: createdViewModel)
    }
    
    func openGameLevel(with number: Int, gameType: LevelType) {
        router.showGame(with: number, gameType: gameType)
    }
}
