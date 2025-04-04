import UIKit

protocol IResultViewController: AnyObject {
    func setup(with: ResultViewModel)
}

final class ResultViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var backGroundImageView: UIImageView!
    @IBOutlet private weak var looseView: UIView!
    @IBOutlet private weak var winLooseView: UIImageView!
    
    // MARK: - Properties
    
    private let presenter: IResultPresenter
    private var resultType: ResultType
    var coins: Int
    
    // MARK: - Lifecycle
    
    init(presenter: IResultPresenter, resultType: ResultType, coins: Int) {
        self.presenter = presenter
        self.resultType = resultType
        self.coins = coins
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch resultType {
        case .win:
            looseView.isHidden = false
            winLooseView.image = UIImage(named: "winImage")
        case .loss:
            looseView.isHidden = false
            winLooseView.image = UIImage(named: "looseImage")
        }
        presenter.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
        if let menuViewController = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            presenter.onHomeButtonTap()
            sender.vibrateSoftly()
            navigationController?.popToViewController(menuViewController, animated: true)
        }
    }
    
    @IBAction func anotherHomeButtonAction(_ sender: UIButton) {
        if let menuViewController = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            presenter.onHomeButtonTap()
            sender.vibrateSoftly()
            navigationController?.popToViewController(menuViewController, animated: true)
        }
    }
}

// MARK: - Extensions

extension ResultViewController: IResultViewController {
    func setup(with viewModel: ResultViewModel) { }
}
