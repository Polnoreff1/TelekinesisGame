import UIKit

protocol ILevelsAssembly {
    func assemble() -> UIViewController
}

final class LevelsAssembly: ILevelsAssembly {
    
    private let viewModelFactory: ILevelsViewModelFactory
    
    // MARK: - Initialization
    
    init(
        viewModelFactory: ILevelsViewModelFactory = LevelsViewModelFactory()
    ) {
        self.viewModelFactory = viewModelFactory
    }
    
    // MARK: - ILevelsAssembly
    
    func assemble() -> UIViewController {
        let router: LevelsRouter = LevelsRouter()
        let presenter: LevelsPresenter = LevelsPresenter(
            viewModelFactory: viewModelFactory,
            router: router
        )
        
        let viewController: LevelsViewController = LevelsViewController(presenter: presenter)
        presenter.view = viewController
        router.transitionHandler = viewController
        
        return viewController
    }
}
