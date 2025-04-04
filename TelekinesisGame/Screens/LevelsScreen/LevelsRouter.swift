import UIKit

protocol ILevelsRouter {
    func showGame(with number: Int)
}

final class LevelsRouter: ILevelsRouter {
    
    weak var transitionHandler: UIViewController?
    
    init() { }
    
    func showGame(with number: Int) {
        let gameScreen = GameViewController(levelIndex: number)
        gameScreen.modalPresentationStyle = .overFullScreen
        transitionHandler?.navigationController?.pushViewController(gameScreen, animated: true)
    }
}
