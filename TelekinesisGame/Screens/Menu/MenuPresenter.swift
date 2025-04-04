import UIKit

protocol IMenuPresenter {
    func viewWillAppear()
    func showLevelsScreen()
    var viewModel: MenuViewModel? { get }
}

final class MenuPresenter: IMenuPresenter {
    
    weak var view: IMenuViewController?
    private let viewModelFactory: IMenuViewModelFactory
    private let router: IMenuRouter
    
    // MARK: - Initialization
    
    init(
        viewModelFactory: IMenuViewModelFactory,
        router: IMenuRouter
    ) {
        self.viewModelFactory = viewModelFactory
        self.router = router
    }
    
    private func getRubyCount() -> Int {
        LevelManager.shared.money
    }
    
    // MARK: - IMenuPresenter
    
    var viewModel: MenuViewModel?
    
    func viewWillAppear() {
        let rubyCount = getRubyCount()
        let createdViewModel = viewModelFactory.makeViewModel(rubyCount: rubyCount)
        viewModel = createdViewModel
        view?.setup(with: createdViewModel)
    }
    
    func showLevelsScreen() {
        router.showLevelsScreen()
    }
}
