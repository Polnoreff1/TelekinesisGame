import UIKit
import SwiftUI

protocol IMenuRouter {
    func showShop()
    func showSettings()
    func showDailyBonusView()
    func showLevelsScreen()
}

final class MenuRouter: IMenuRouter {
    
    weak var transitionHandler: UIViewController?
    private let levelsAssembly: ILevelsAssembly
    
    init(levelsAssembly: ILevelsAssembly) {
       
        self.levelsAssembly = levelsAssembly
    }
    
    func showShop() {
//        let hostingController = UIHostingController(rootView: ShopView().environmentObject(ShowFlowVC()))
//        hostingController.navigationController?.setNavigationBarHidden(true, animated: true)
//        transitionHandler?.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func showSettings() {
        let hostingController = UIHostingController(rootView: Settings())
        hostingController.navigationController?.setNavigationBarHidden(true, animated: true)
        transitionHandler?.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func showDailyBonusView() {
//        let hostingController = UIHostingController(rootView: DailyBonus())
//        transitionHandler?.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func showLevelsScreen() {
        let levelScreens = levelsAssembly.assemble()
        levelScreens.modalPresentationStyle = .currentContext
        transitionHandler?.navigationController?.pushViewController(levelScreens, animated: true)
    }
}
