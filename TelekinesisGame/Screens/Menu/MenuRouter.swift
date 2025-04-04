import UIKit
import SwiftUI

protocol IMenuRouter {
    func showLevelsScreen()
}

final class MenuRouter: IMenuRouter {
    
    weak var transitionHandler: UIViewController?
    private let levelsAssembly: ILevelsAssembly
    
    init(levelsAssembly: ILevelsAssembly) {
        
        self.levelsAssembly = levelsAssembly
    }
    
    func showLevelsScreen() {
        let levelScreens = levelsAssembly.assemble()
        levelScreens.modalPresentationStyle = .currentContext
        transitionHandler?.navigationController?.pushViewController(levelScreens, animated: true)
    }
}
