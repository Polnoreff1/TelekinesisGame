//
//  LevelsRouter.swift
//  Maria-Casino
//
//  Created by 1234 on 29.03.2023.
//
//

import UIKit

protocol ILevelsRouter {
    func showGame(with number: Int, gameType: LevelType)
}

final class LevelsRouter: ILevelsRouter {
    
    weak var transitionHandler: UIViewController?
    
    init() {
    }
    
    func showGame(with number: Int, gameType: LevelType) {
        let gameScreen = GameViewController(levelIndex: number, gameType: gameType)
        gameScreen.modalPresentationStyle = .overFullScreen
        transitionHandler?.navigationController?.pushViewController(gameScreen, animated: true)
    }
}
