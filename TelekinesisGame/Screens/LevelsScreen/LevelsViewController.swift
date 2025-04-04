import UIKit
import AVFoundation

protocol ILevelsViewController: AnyObject {
    func setup(with: LevelsViewModel)
}

final class LevelsViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var levelstTableView: UITableView!
    
    // MARK: - Properties
    
    private let presenter: ILevelsPresenter
    private var isCameraAccessGranted: Bool = false
    
    // MARK: - Lifecycle
    
    init(presenter: ILevelsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkCameraAccess()
        
        presenter.viewDidLoad()
        levelstTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
        requestCameraPermission()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        levelstTableView.delegate = self
        levelstTableView.dataSource = self
        levelstTableView.separatorStyle = .none
        levelstTableView.rowHeight = 76
        levelstTableView.estimatedRowHeight = 76
        let nib = UINib(nibName: String(describing: LevelTableViewCell.self), bundle: nil)
        levelstTableView.register(nib, forCellReuseIdentifier: String(describing: LevelTableViewCell.self))
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.isCameraAccessGranted = granted
            }
        }
    }
    
    private func checkCameraAccess() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        isCameraAccessGranted = (status == .authorized)
    }
    
    private func showCameraAccessAlert() {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "The game uses gesture recognition via the smartphone camera. You can enable camera access in the settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension LevelsViewController: ILevelsViewController {
    func setup(with viewModel: LevelsViewModel) {}
}

extension LevelsViewController: UITableViewDelegate {}

extension LevelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.viewModel?.cellModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LevelTableViewCell.identifier,
            for: indexPath
        ) as? LevelTableViewCell,
              let cellViewModel = presenter.viewModel?.cellModels[indexPath.row] else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.setup(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = presenter.viewModel?.cellModels[indexPath.row] {
            if !cellModel.isLocked {
                if isCameraAccessGranted {
                    presenter.openGameLevel(with: cellModel.number)
                } else {
                    showCameraAccessAlert()
                }
            }
        }
    }
}
