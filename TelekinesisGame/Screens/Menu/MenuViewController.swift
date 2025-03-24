import UIKit
import Lottie

protocol IMenuViewController: AnyObject {
    func setup(with: MenuViewModel)
}

final class MenuViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var shopButton: UIButton!
    @IBOutlet private weak var dailyBonusMenuButton: UIButton!
    @IBOutlet private weak var moneyLabel: UILabel!
    
    // MARK: - Properties
    
    private let presenter: IMenuPresenter
    
    private lazy var loaderLottieViewSoka: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "bgMenu")
        animationView.frame = view.frame
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.1
        animationView.contentMode = .scaleAspectFill
        
        return animationView
    }()
    
    // MARK: - Lifecycle
    
    init(presenter: IMenuPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(loaderLottieViewSoka, at: 0)
        NSLayoutConstraint.activate([
            loaderLottieViewSoka.topAnchor.constraint(equalTo: view.topAnchor),
            loaderLottieViewSoka.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loaderLottieViewSoka.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderLottieViewSoka.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        loaderLottieViewSoka.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !SoundMusicManager.shared.isPlaying {
            SoundMusicManager.shared.playMenuBackgroundMusic()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        dailyBonusMenuButton.isUserInteractionEnabled = !LevelManager.shared.isDailyBonusCollected
        dailyBonusMenuButton.isHidden = LevelManager.shared.isDailyBonusCollected
        presenter.viewWillAppear()
        moneyLabel.text = "\(LevelManager.shared.money)"
        
        LevelManager.shared.money = 3000 // delete
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        presenter.showLevelsScreen()
    }
    
    @IBAction func settingsButtonAction(_ sender: UIButton) {
        presenter.showSettingsScreen()
    }
    
    @IBAction func shopButtonAction(_ sender: UIButton) {
        presenter.showShopScreen()
    }
    
    @IBAction func dailyBonusMenuButtonAction(_ sender: Any) {
        presenter.showDailyBonusView()
    }
}

// MARK: - Extensions

extension MenuViewController: IMenuViewController {
    func setup(with viewModel: MenuViewModel) {
    }
}
