import UIKit

protocol IResultViewController: AnyObject {
    func setup(with: ResultViewModel)
}

final class ResultViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var backGroundImageView: UIImageView!
    @IBOutlet weak var looseView: UIView!
    @IBOutlet weak var winView: UIView!
    
    @IBOutlet weak var winAmountLabel: UILabel!
    
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
            winAmountLabel.text = "\(coins)"
            looseView.isHidden = true
            winView.isHidden = false
            DispatchQueue.main.async {
                SoundMusicManager.shared.playSound(nameSound: .victorySound)
            }
        case .loss:
            looseView.isHidden = false
            winView.isHidden = true
            DispatchQueue.main.async {
                SoundMusicManager.shared.playSound(nameSound: .gameOverSound)
            }
        }
        presenter.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
        if let menuViewController = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            presenter.onHomeButtonTap()
            SoundMusicManager.shared.playMenuBackgroundMusic()
            sender.vibrateSoftly()
            navigationController?.popToViewController(menuViewController, animated: true)
        }
    }
    
    @IBAction func anotherHomeButtonAction(_ sender: UIButton) {
        if let menuViewController = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            presenter.onHomeButtonTap()
            SoundMusicManager.shared.playMenuBackgroundMusic()
            sender.vibrateSoftly()
            navigationController?.popToViewController(menuViewController, animated: true)
        }
    }
}

// MARK: - Extensions

extension ResultViewController: IResultViewController {
    func setup(with viewModel: ResultViewModel) { }
}
