import UIKit
import Lottie
import SwiftUI

final class LoaderViewControllerMia: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var loadingImageView: UIImageView!
    @IBOutlet private weak var progressBGView: UIView!
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.frame.size = CGSize(width: 250, height: 80)
        progressView.progressTintColor = UIColor(named: "loaderColor")
        progressView.trackTintColor = .clear
        progressView.progressImage = UIImage(named: "progressBarImage")
        progressView.progress = 0.0
        progressView.transform = CGAffineTransform(scaleX: 1, y: 4)
        return progressView
    }()
    
    private lazy var loaderLottieViewSoka: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "loader")
        animationView.frame = view.frame
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.1
        animationView.contentMode = .scaleAspectFill
        
        return animationView
    }()
    
    var isInitial: Bool
    
    // MARK: - Lifecycle
    
    init(isInitial: Bool) {
        self.isInitial = isInitial
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let isFirstStartCompleted = UserDefaults.standard.bool(forKey: "IsFirstStart")
        if !isFirstStartCompleted {
            UserDefaults.standard.set(true, forKey: "IsFirstStart")
        }
        view.addSubview(loaderLottieViewSoka)
        NSLayoutConstraint.activate([
            loaderLottieViewSoka.topAnchor.constraint(equalTo: view.topAnchor),
            loaderLottieViewSoka.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loaderLottieViewSoka.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderLottieViewSoka.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        loaderLottieViewSoka.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        var font = UIFont(name: inAppFontName, size: 12)
        //        print(font)
        
        if isInitial {
            // "это будет длится бесконечно"
        } else {
            let randomCount = Int.random(in: 2...3)
            let piece = 1.0 / Float(randomCount)
            for i in 1...randomCount {
                self.progressView.setProgress(Float(i) * piece, animated: true)
                RunLoop.current.run(until: Date() + Double.random(in: 0.8...1.5))
            }
            
            UIView.animate(withDuration: 0.4) {
            } completion: { isFinished in
                if isFinished {
                    let menuViewController = MenuAssembly().assemble()
                    let transition = CATransition()
                    transition.duration = 0.25
                    transition.type = .fade
                    if let window = UIApplication.shared.windows.first {
                        window.layer.add(transition, forKey: "fade")
                        window.rootViewController = UINavigationController(rootViewController: menuViewController)
                    }
                }
            }
        }
    }
}
