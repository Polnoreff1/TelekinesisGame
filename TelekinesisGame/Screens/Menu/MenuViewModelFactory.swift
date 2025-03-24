import UIKit

protocol IMenuViewModelFactory {
    func makeViewModel(rubyCount: Int) -> MenuViewModel
}

final class MenuViewModelFactory: IMenuViewModelFactory {
    
    func makeViewModel(rubyCount: Int) -> MenuViewModel {
        let viewModel: MenuViewModel = MenuViewModel(coinsCount: String(rubyCount))
        return viewModel
    }
}
