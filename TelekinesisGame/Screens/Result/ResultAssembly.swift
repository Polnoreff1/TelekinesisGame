import UIKit

protocol IResultAssembly {
    func assemble(with type: ResultType, coins: Int) -> UIViewController
}

final class ResultAssembly: IResultAssembly {
    
    private let viewModelFactory: IResultViewModelFactory
    
    // MARK: - Initialization
    
    init(viewModelFactory: IResultViewModelFactory = ResultViewModelFactory()) {
        self.viewModelFactory = viewModelFactory
    }
    
    // MARK: - IResultAssembly
    
    func assemble(with type: ResultType, coins: Int) -> UIViewController {
        let presenter: ResultPresenter = ResultPresenter(
            viewModelFactory: viewModelFactory,
            resultType: type
        )
        
        let viewController: ResultViewController = ResultViewController(
            presenter: presenter,
            resultType: type,
            coins: coins
        )
        presenter.view = viewController
        
        return viewController
    }
}
