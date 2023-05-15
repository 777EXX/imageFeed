import UIKit
import SnapKit
import Kingfisher
import ProgressHUD

final class ImageListViewController: UIViewController, ImageListViewControllerProtocol {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    var presenter: ImageListViewPresenterProtocol?
    var alertPresenter: AlertPresenter?
    let imageListView = ImageListView()
    let dateService = DateService()
    var heightsOfRows: [String: CGFloat] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageListView.setTableViewDelegateAndDataSource(self)
        presenter?.setupObservers()
        
        setTableView()
    }
    
    func requestFullSizeImage(viewController: SingleImageViewController, url: URL) {
        UIBlockingProgressHUD.show()
        viewController.imageView.kf.setImage(
            with: url, placeholder: UIImage(named: "DownloadingImage")) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageResult):
                        UIBlockingProgressHUD.dismiss()
                        viewController.rescaleAndCenterImageInScrollView(image: imageResult.image)
                    case .failure(_:):
                        UIBlockingProgressHUD.dismiss()
                        self.alertPresenter?.presentErrorAlert()
                    }
                }
            }
    }
    
    func switchToSingleViewController(sender: Any?, viewController: UIViewController) {
        let toViewController = SingleImageViewController()
        toViewController.modalPresentationStyle = .overFullScreen
        
        guard let indexPath = sender as? IndexPath else { return }
        let cellPhotoURL = presenter?.photos[indexPath.row].largeImageURL ?? ""
        
        if let url = URL(string: cellPhotoURL) {
            requestFullSizeImage(viewController: toViewController, url: url)
            
            viewController.present(toViewController, animated: true)
        }
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        imageListView.tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            imageListView.tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in
        }
    }
    
    private func setTableView() {
        view.addSubview(imageListView.tableView)
        
        imageListView.tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIBlockingProgressHUD.dismiss()
        guard let presenter = presenter else { return 100 }
        let image = presenter.photos[indexPath.row]
        for element in heightsOfRows {
            if element.key == image.id {
                return element.value
            }
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        heightsOfRows[image.id] = cellHeight
        
        return cellHeight
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as! ImagesListCell
        imageListCell.delegate = self
        guard let cellPhotoURL = presenter?.photos[indexPath.row].thumbImageURL,
              let isLiked = self.presenter?.photos[indexPath.row].isLiked else {
            return UITableViewCell(style: .default, reuseIdentifier: "") }
        
        if let url = URL(string: cellPhotoURL)  {
            let downloadImage = UIImage(named: "DownloadingImage")
            imageListCell.cellImage.kf.setImage(with: url, placeholder: downloadImage) {
                [weak self] _ in
                guard let self = self else { return }
                imageListCell.cellImage.kf.indicatorType = .activity
                imageListCell.cellLabel.text = self.presenter?.dateService?.dateToString(
                    date: self.presenter?.photos[indexPath.row].createdAt)
                let image = self.presenter?.setLikeButtonImage(isLiked: isLiked)
                imageListCell.likeButton.setImage(image, for: .normal)
            }
        }
        return imageListCell
    }
}

extension ImageListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchToSingleViewController(sender: indexPath, viewController: self)
    }
}

extension ImageListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.photos.count {
            guard let token = presenter?.token else { return }
            UIBlockingProgressHUD.show()
            presenter?.imagesListService?.fetchPhotosNextPage(token)
        }
    }
}

extension ImageListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = imageListView.tableView.indexPath(for: cell),
              let presenter = presenter else { return }
        let photo = presenter.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        presenter.imagesListService?.changeLike(photoID: photo.id, isLiked: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let newPhoto = Photo(id: photo.id,
                                         size: photo.size,
                                         createdAt: photo.createdAt,
                                         welcomeDescription: photo.welcomeDescription,
                                         thumbImageURL: photo.thumbImageURL,
                                         largeImageURL: photo.largeImageURL,
                                         isLiked: !photo.isLiked)
                    presenter.photos[indexPath.row] = newPhoto
                    
                    cell.likeButton.layer.removeAllAnimations()
                    
                    let image = presenter.setLikeButtonImage(isLiked: presenter.photos[indexPath.row].isLiked)
                    UIView.transition(with: cell.likeButton, duration: 0.5, options: .transitionCrossDissolve) {
                        cell.likeButton.setImage(image, for: .normal)
                    }
                    UIBlockingProgressHUD.dismiss()
                case .failure(_:):
                    UIBlockingProgressHUD.dismiss()
                    self.alertPresenter?.presentErrorAlert()
                }
            }
        }
    }
}
