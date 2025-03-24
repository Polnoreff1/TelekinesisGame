import Foundation
import UIKit
import WebKit

final class PrivacyPolicyViewController: UIViewController {
    
    let privacyStr = "https://docs.google.com/document/d/1D0G0Io49MDfqZxT9sdyxy4roBS8QFUxY-LLQcRd8eAs/edit?usp=sharing"
    static var storyboardId: String { String(describing: Self.self) }
    private var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    private func setupWebView() {
        let request = URLRequest(url: URL(string: privacyStr)!)
        webView.load(request)
    }
}
