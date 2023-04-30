import UIKit
import SnapKit


final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    private var splash = SplashViewController()
    
    private lazy var screenLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Resourses.Images.authScreenLogo
        
        return imageView
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypWhiteIOS
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.ypBlack, for: .normal)
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(switchToWebWiew), for: .touchDown)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateScreen()
    }
    
    private func configurateScreen() {
        view.backgroundColor = .ypBlack

        view.addSubview(enterButton)
        view.addSubview(screenLogo)
      
        screenLogo.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.center.equalToSuperview()
        }
        
        enterButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(-124)
        }
    }
    
    private func swithToTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .overFullScreen
        
        present(tabBarController, animated: true)
    }
    
    @objc private func switchToWebWiew() {
       let viewController = WebViewViewController()
        
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }


    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}


