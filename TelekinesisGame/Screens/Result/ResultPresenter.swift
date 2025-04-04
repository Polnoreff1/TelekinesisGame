import UIKit

protocol IResultPresenter {
    func viewDidLoad()
    func onBackButtonTap()
    func onHomeButtonTap()
    var viewModel: ResultViewModel? { get }
}

final class ResultPresenter: IResultPresenter {
    
    weak var view: IResultViewController?
    private let viewModelFactory: IResultViewModelFactory
    private let resultType: ResultType
    var onBackButtonClick: (() -> Void)?
    var onHomeButtonClick: (() -> Void)?
    
    // MARK: - Initialization
    
    init(
        viewModelFactory: IResultViewModelFactory,
        resultType: ResultType
    ) {
        self.viewModelFactory = viewModelFactory
        self.resultType = resultType
    }
    
    // MARK: - IResultPresenter
    
    var viewModel: ResultViewModel?
    
    func viewDidLoad() {
        let createdViewModel = viewModelFactory.makeViewModel(resultType: resultType)
        viewModel = createdViewModel
        view?.setup(with: createdViewModel)
    }
    
    func onBackButtonTap() {
        onBackButtonClick?()
    }
    
    func onHomeButtonTap() {
        onHomeButtonClick?()
    }
}
