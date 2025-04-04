import UIKit

protocol IMenuAssembly {
    func assemble() -> UIViewController
}

final class MenuAssembly: IMenuAssembly {
    
    private let viewModelFactory: IMenuViewModelFactory
    private let levelsAssembly: ILevelsAssembly
    
    // MARK: - Initialization
    
    init(
        viewModelFactory: IMenuViewModelFactory = MenuViewModelFactory(),
        levelsAssembly: ILevelsAssembly = LevelsAssembly()
    ) {
        self.viewModelFactory = viewModelFactory
        self.levelsAssembly = levelsAssembly
    }
    
    // MARK: - IMenuAssembly
    
    func assemble() -> UIViewController {
        let router: MenuRouter = MenuRouter(
            levelsAssembly: levelsAssembly
        )
        let presenter: MenuPresenter = MenuPresenter(
            viewModelFactory: viewModelFactory,
            router: router
        )
        
        let viewController: MenuViewController = MenuViewController(presenter: presenter)
        presenter.view = viewController
        router.transitionHandler = viewController
        
        return viewController
    }
}
