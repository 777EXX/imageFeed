import UIKit
import SnapKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileInfoServiceObserver: NSObjectProtocol?
    
    private let profileService = ProfileService.shared
    private let token = OAuth2TokenStorage().token
    
    private lazy var accountAvatarImage: UIImageView = {
        let imageViews = UIImageView()
        let image = Resourses.Images.accountAvatar
                
        imageViews.layer.cornerRadius = 35
        imageViews.layer.masksToBounds = true
        
        return imageViews
    }()
    private lazy var accountFullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resourses.Colors.ypWhiteOS
        label.font = Resourses.Fonts.SFProTextBold
        
        return label
    }()
    
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resourses.Colors.ypGray
        label.font = Resourses.Fonts.SFProTextRegular
        
        return label
    }()
    
    private lazy var accountDescription: UILabel = {
        let label = UILabel()
        label.textColor = Resourses.Colors.ypWhite
        label.font = Resourses.Fonts.SFProTextRegular
        
        return label
    }()
    
    private lazy var accountLogoutButton: UIButton = {
        let button = UIButton()
        let image = Resourses.Images.accountLogoutButton
        button.setImage(image, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        profileAvatarObserver()
        profileInfoObserver()
            
        setAccountAvatarImage()
        setAccountFullNameLabel()
        setUsernameLabel()
        setAccountDescriptionLabel()
        setAccountLogoutButton()
    }
    
    // Updating profile:
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL) else { return }
        accountAvatarImage.kf.setImage(with: url, placeholder: Resourses.Images.avatarPlaceHolder)
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
            accountFullNameLabel.text = profile.fullName
            userLabel.text = profile.username
            accountDescription.text = profile.bio
        }
    
    // Profile observers:
    
    private func profileInfoObserver() {
        profileInfoServiceObserver = NotificationCenter.default.addObserver(
            forName: SplashViewController.didChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.updateProfileDetails(profile: self.profileService.profile)
            }
        updateProfileDetails(profile: profileService.profile)
    }
    
    private func profileAvatarObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    // Functions of setting UI - elements:
    
    private func setAccountAvatarImage() {
        view.addSubview(accountAvatarImage)
        accountAvatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.top.equalToSuperview().inset(76)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    private func setAccountFullNameLabel() {
        view.addSubview(accountFullNameLabel)
        accountFullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountAvatarImage.snp.bottom).inset(-8)
            make.leading.equalTo(accountAvatarImage)
        }
    }
    
    private func setUsernameLabel() {
        view.addSubview(userLabel)
        userLabel.snp.makeConstraints { make in
            make.top.equalTo(accountFullNameLabel.snp.bottom).inset(-8)
            make.leading.equalTo(accountFullNameLabel)
        }
    }
    
    private func setAccountDescriptionLabel() {
        view.addSubview(accountDescription)
        accountDescription.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).inset(-8)
            make.leading.equalTo(userLabel)
        }
    }
    
    private func setAccountLogoutButton() {
        view.addSubview(accountLogoutButton)
        accountLogoutButton.addTarget(self, action: #selector(logoutProfile), for: .touchDown)
        accountLogoutButton.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(22)
            make.centerY.equalTo(accountAvatarImage.snp.centerY)
            make.trailing.equalToSuperview().inset(26)
        }
    }
    
    @objc private func logoutProfile() {
        let splashVC = SplashViewController()
        splashVC.modalPresentationStyle = .overFullScreen
        
        present(splashVC, animated: true)
        OAuth2TokenStorage().deleteToken()
    }
}
