import UIKit
import SnapKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    var profileService: ProfileServiceProtocol?
    
    private let profileView = ProfileView()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        presenter?.setupObservers()
        presenter?.fetchProfile()
        
        setAccountAvatarImage()
        setAccountFullNameLabel()
        setUsernameLabel()
        setAccountDescriptionLabel()
        setAccountLogoutButton()
    }
    
    // Updating profile:
    
    func updateAvatar(_ imageView: UIImageView) {
        profileView.accountAvatarImage.image = imageView.image
    }
    
    func updateProfileDetails() {
        profileView.accountFullNameLabel.text = presenter?.profile?.fullName
        profileView.userLabel.text = presenter?.profile?.username
        profileView.accountDescription.text = presenter?.profile?.bio
    }
    
    @objc private func logoutProfile() {
        presenter?.showLogoutAlert(controller: self)
    }
    
    // Functions of setting UI - elements:
    
    private func setAccountAvatarImage() {
        view.addSubview(profileView.accountAvatarImage)
        profileView.accountAvatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.top.equalToSuperview().inset(76)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    private func setAccountFullNameLabel() {
        view.addSubview(profileView.accountFullNameLabel)
        profileView.accountFullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.accountAvatarImage.snp.bottom).inset(-8)
            make.leading.equalTo(profileView.accountAvatarImage)
        }
    }
    
    private func setUsernameLabel() {
        view.addSubview(profileView.userLabel)
        profileView.userLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.accountFullNameLabel.snp.bottom).inset(-8)
            make.leading.equalTo(profileView.accountFullNameLabel)
        }
    }
    
    private func setAccountDescriptionLabel() {
        view.addSubview(profileView.accountDescription)
        profileView.accountDescription.snp.makeConstraints { make in
            make.top.equalTo(profileView.userLabel.snp.bottom).inset(-8)
            make.leading.equalTo(profileView.userLabel)
        }
    }
    
    private func setAccountLogoutButton() {
        view.addSubview(profileView.accountLogoutButton)
        profileView.accountLogoutButton.addTarget(self, action: #selector(logoutProfile), for: .touchDown)
        profileView.accountLogoutButton.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(22)
            make.centerY.equalTo(profileView.accountAvatarImage.snp.centerY)
            make.trailing.equalToSuperview().inset(26)
        }
    }
}
