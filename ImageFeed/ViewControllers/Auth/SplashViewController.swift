import UIKit
import ProgressHUD
import SnapKit


final class SplashViewController: UIViewController {
    
    private let screenLogoView = UIImageView()
    private var profileInfoServiceObserver: NSObjectProtocol?
    
    private let imageListVicewController = ImageListViewController()
    private let oAuth2Service = OAuth2Service()
    private let imageListService = ImagesListService.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var username: String?
    private var isFirst = true
    
    static let didChangeNotification = Notification.Name("ProfileInfoDidRecieve")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setScreen()
        
        checkToken()
        
        addPhotoDownloadedObserver()
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
                self.imageListService.fetchPhotosNextPage()
                self.switchToTabBarController()
                self.fetchProfile(token: token)
            case .failure(let error):
                self.showAlert()
                print("ошибка получения bearer token  \(error)")
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.username = profile.username
                self.fetchImageProfile(token: token)
                NotificationCenter.default.post(
                    name: SplashViewController.didChangeNotification,
                    object: self,
                    userInfo: ["ProfileInfo": self.profileService.profile!])
            case .failure(let error):
                self.showAlert()
                print(error)
            }
        }
    }
    
    private func fetchImageProfile(token: String) {
        profileImageService.fetchProfileImageURL(username: username!, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": self.profileImageService.avatarURL!])
            case .failure(let error):
                self.showAlert()
                print(error)
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        self.present(self, animated: true)
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
    
    private func checkToken() {
        if isFirst {
            if let token = OAuth2TokenStorage().token {
                imageListService.fetchPhotosNextPage()
                fetchProfile(token: token)
            } else {
                switchToAuthViewController()
                isFirst = false
            }
        } else {
            switchToTabBarController()
        }
    }
    private func addPhotoDownloadedObserver() {
        profileInfoServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.switchToTabBarController()
            }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
}

