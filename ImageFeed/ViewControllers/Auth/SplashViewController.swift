import UIKit
import ProgressHUD
import SnapKit


final class SplashViewController: UIViewController {
    
    private let screenLogoView = UIImageView()
    
    private let oAuth2Service = OAuth2Service()
    private var alertPresenter: AlertPresenter?
    private var username: String?
    private var isFirstEntry = true
    
    static let didChangeNotification = Notification.Name("AuthTokenDidRecived")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        alertPresenter = AlertPresenter(viewController: self)
        setScreen()
        
        checkToken()
    }
    
    private func switchToTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .overFullScreen
        
        present(tabBarController, animated: true)
    }
    
    private func switchToAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        
        present(authViewController, animated: true)
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage().token = token
                NotificationCenter.default.post(name: SplashViewController.didChangeNotification,
                                                object: self,
                                                userInfo: ["Token": token])
            case .failure(let error):
                self.alertPresenter?.presentErrorAlert()
                print("ошибка получения bearer token  \(error)")
            }
        }
    }
    
    private func checkToken() {
        if isFirstEntry {
            if let _ = OAuth2TokenStorage().token {
                switchToTabBarController()
            } else {
                switchToAuthViewController()
            }
        } else {
            switchToTabBarController()
        }
    }
    
    private func setScreen() {
        view.addSubview(screenLogoView)
        view.backgroundColor = .ypBlack
        
        screenLogoView.image = Resourses.Images.vector
        
        screenLogoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(77.68)
            make.width.equalTo(75)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        isFirstEntry = false
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
}

