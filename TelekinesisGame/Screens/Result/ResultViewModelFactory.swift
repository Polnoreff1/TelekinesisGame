import UIKit

protocol IResultViewModelFactory {
    func makeViewModel(resultType: ResultType) -> ResultViewModel
}

final class ResultViewModelFactory: IResultViewModelFactory {
    
    func makeViewModel(resultType: ResultType) -> ResultViewModel {
        let image: UIImage?
        switch resultType {
        case .win:
            image = UIImage(named: "winBG")
        case .loss:
            image = UIImage(named: "loseBG")
        }
        let viewModel: ResultViewModel = ResultViewModel(bgImage: nil, mainImage: image, resultType: resultType)
        return viewModel
    }
}
