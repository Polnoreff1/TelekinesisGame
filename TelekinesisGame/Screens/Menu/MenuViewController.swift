import UIKit
import Lottie

protocol IMenuViewController: AnyObject {
    func setup(with: MenuViewModel)
}

final class MenuViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var playButton: UIButton!
    
    // MARK: - Properties
    
    private let presenter: IMenuPresenter
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        presenter.viewWillAppear()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        presenter.showLevelsScreen()
    }
}

// MARK: - Extensions

extension MenuViewController: IMenuViewController {
    func setup(with viewModel: MenuViewModel) {
    }
}
