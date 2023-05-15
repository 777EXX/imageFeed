import UIKit
import SnapKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        button.accessibilityIdentifier = "LikeButton"
        
        return button
    }()
    
    lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhiteIOS
        
        return label
    }()
    
    lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .ypBlack
        
        return imageView
    }()
    
    lazy var gradientImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    var lowerGradientImage: CAGradientLayer = {
        let layer = CAGradientLayer()
        
        return layer
    }()
    
    override func layoutSubviews() {
        gradientImageView.layer.sublayers = nil
        
        setCellImage()
        setLikeButton()
        
        cellImage.backgroundColor = .white
        
        setGradientView()
        setCellLabel()
    }
    
    override func prepareForReuse() {
        gradientImageView.layer.sublayers = nil
        cellImage.kf.cancelDownloadTask()
    }
    
    private func setCellImage() {
        contentView.addSubview(cellImage)
        
        cellImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    private func setGradientView() {
        contentView.addSubview(gradientImageView)
        gradientImageView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(cellImage)
            make.height.equalTo(30)
        }
        cellImage.addGradient(topColor: UIColor.imageStartGradient, botColor: UIColor.imageEndGradient,
                              gradientLayer: lowerGradientImage)
    }
    
    private func setCellLabel() {
        contentView.addSubview(cellLabel)
        cellLabel.snp.makeConstraints { make in
            make.leading.bottom.equalTo(cellImage).inset(8)
            make.trailing.lessThanOrEqualTo(cellImage)
            make.top.equalTo(gradientImageView.snp.top).offset(4)
        }
    }
    
    private func setLikeButton() {
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.height.width.equalTo(42)
            make.top.equalTo(cellImage).inset(12)
            make.trailing.equalTo(cellImage).inset(10.5)
        }
    }
    
    private func setupGradient() {
        let height = gradientImageView.bounds.height
        let widht = gradientImageView.bounds.width
        
        let colorTop = UIColor.imageStartGradient.cgColor
        let colorBot = UIColor.imageEndGradient.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame  = CGRect(x: 0, y: 0, width: widht, height: height)
        gradientLayer.colors = [colorTop, colorBot]
        gradientImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func likeButtonClicked() {
        
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.repeat]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.75) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        delegate?.imageListCellDidTapLike(self)
    }
}
