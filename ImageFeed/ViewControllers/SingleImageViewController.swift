import UIKit
import SnapKit


final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    private lazy var scrollView: UIScrollView! = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var activityButton: UIButton = {
        let button = UIButton()
        button.setImage(Resourses.Images.activity, for: .normal)
        button.setTitleColor(.ypWhiteIOS, for: .normal)
        
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Resourses.Images.backButtonWhite, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = .ypBlack
        setScrollView()
        setImageView()
        setActivityButton()
        setBackButton()
        
        rescaleAndCenterImageInScrollView(image: image)
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func setScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setImageView() {
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setActivityButton() {
        view.addSubview(activityButton)
        activityButton.addTarget(self, action: #selector(didTapShareButton), for: .touchDown)
        activityButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(51)
        }
    }
    
    private func setBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchDown)
        backButton.snp.makeConstraints { make in
            make.width.equalTo(8.97)
            make.height.equalTo(15.59)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(60)
        }
    }
    
    @objc private func didTapShareButton() {
        guard let shareImage = image else { return }
        let shareController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        present(shareController, animated: true)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(image: UIImage){
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.height / imageSize.height
        let wScale = visibleRectSize.width / imageSize.width
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, wScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
