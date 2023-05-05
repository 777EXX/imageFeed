import UIKit
import WebKit
import SnapKit

final class WebViewViewController: UIViewController {
    
    private let constant = Constants()
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    
    private lazy var webView: WKWebView! = {
        let webView = WKWebView()
        view.addSubview(webView)
        webView.backgroundColor = .ypWhiteIOS
        
        return webView
    }()
    
    private lazy var progressView: UIProgressView! = {
        let progressView = UIProgressView()
        view.addSubview(progressView)
        progressView.progressTintColor = .ypBlack
        
        return progressView
    }()
    
    private lazy var didTapBackButton: UIButton = {
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.setImage(Resourses.Images.backButtonBlack, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(dismissWebView), for: .touchDown)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        sentRequestToUnsplashAPI()
        setViews()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
            changeHandler: { [weak self] _, _ in
                guard let self = self else { return }
                self.updateProgress()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressView.isHidden = true
 }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.001
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == Constants.urlPathToAutorize,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == ParametersNames.code})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    private func sentRequestToUnsplashAPI() {
        var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: ParametersNames.clientID, value: Constants.accessKey),
            URLQueryItem(name: ParametersNames.redirectUri, value: Constants.redirectURI),
            URLQueryItem(name: ParametersNames.responseType, value: ParametersNames.code),
            URLQueryItem(name: ParametersNames.scope, value: Constants.accessScope)
        ]
        
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        print(request)
        self.webView.load(request)
    }
    
    private func setViews() {
        webView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        didTapBackButton.snp.makeConstraints { make in
            make.height.equalTo(15.59)
            make.width.equalTo(8.97)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(60)
        }
        progressView.snp.makeConstraints { make in
            make.bottom.equalTo(didTapBackButton).offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
   @objc private func dismissWebView() {
        delegate?.webViewViewControllerDidCancel(self)
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
