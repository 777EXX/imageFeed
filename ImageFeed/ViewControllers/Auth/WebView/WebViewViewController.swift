import UIKit
import WebKit
import SnapKit

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private var webView = WebView()
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.webView.navigationDelegate = self
        setViews()
        addTargets()
        
        presenter?.didLoad()
        updateProgressObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.progressView.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func updateProgressObserver() {
        estimatedProgressObservation = webView.webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 presenter?.didUpdateProgressValue(webView.webView.estimatedProgress)
             })
    }
    
    func setProgressValue(_ newValue: Float) {
        webView.progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        webView.progressView.isHidden = isHidden
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
    
    func load(request: URLRequest) {
        webView.webView.load(request)
    }
    
    private func addTargets() {
        webView.didTapBackButton.addTarget(self, action: #selector(dismissWebView), for: .touchDown)
    }
    
    @objc private func dismissWebView() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes,
                                                        for: [record], completionHandler: {})
            }
        }
    }
}

extension WebViewViewController {
    private func setViews() {
        view.addSubview(webView.webView)
        view.addSubview(webView.progressView)
        view.addSubview(webView.didTapBackButton)
        
        webView.webView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        webView.didTapBackButton.snp.makeConstraints { make in
            make.height.equalTo(15.59)
            make.width.equalTo(8.97)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(60)
        }
        webView.progressView.snp.makeConstraints { make in
            make.bottom.equalTo(webView.didTapBackButton).offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            self.delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            UIBlockingProgressHUD.show()
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
