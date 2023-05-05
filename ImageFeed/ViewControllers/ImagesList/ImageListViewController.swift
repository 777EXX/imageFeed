import UIKit
import SnapKit
import Kingfisher
import ProgressHUD

final class ImageListViewController: UIViewController {
    
    private let imagesListService = ImagesListService.shared
    private var profileInfoServiceObserver: NSObjectProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private var photos: [Photo] = []
    private var heightsOfRows: [String:CGFloat] = [:]
    
    private lazy var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12,
                                              left: 0,
                                              bottom: 12,
                                              right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos = imagesListService.photos
        
        photosObserver()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setTableView()
    }
    
    private func switchToSingleViewController(sender: Any?) {
        let viewController = SingleImageViewController()
        viewController.modalPresentationStyle = .overFullScreen
        
        guard let indexPath = sender as? IndexPath else { return }
        let cellPhotoURL = self.photos[indexPath.row].largeImageURL
        
        if let url = URL(string: cellPhotoURL) {
            requestFullSizeImage(viewController: viewController, url: url)
            
            present(viewController, animated: true)
        }
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func photosObserver() {
        profileInfoServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        updateTableViewAnimated()
    }
    
    private func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Попробовать еще раз?",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Нет", style: .default)
        alert.addAction(action)
        
        self.present(self, animated: true)
    }
    
    private func setLikeButtonImage(isLiked: Bool) -> UIImage {
        let image = isLiked ? Resourses.Images.likeActive : Resourses.Images.likeInactive
        return image!
    }
    
    private func requestFullSizeImage(viewController: SingleImageViewController, url: URL) {
        UIBlockingProgressHUD.show()
        viewController.imageView.kf.setImage(
            with: url, placeholder: UIImage(named: "DownloadingImage")) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageResult):
                        UIBlockingProgressHUD.dismiss()
                        viewController.rescaleAndCenterImageInScrollView(image: imageResult.image)
                    case .failure(let error):
                        UIBlockingProgressHUD.dismiss()
                        self.showAlert(error)
                    }
                }
            }
    }
    private func dateToString(date: Date?) -> String {
        guard let date = date else { return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let string = dateFormatter.string(from: date)
        return string
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = self.photos[indexPath.row]
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
        
        let cellPhotoURL = self.photos[indexPath.row].thumbImageURL
        if let url = URL(string: cellPhotoURL)  {
            imageListCell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "DownloadingImage")) {
                [weak self] _ in
                guard let self = self else { return }
                imageListCell.cellImage.kf.indicatorType = .activity
                imageListCell.cellLabel.text = self.dateToString(date: self.photos[indexPath.row].createdAt)
                let image = self.setLikeButtonImage(isLiked: self.photos[indexPath.row].isLiked)
                imageListCell.likeButton.setImage(image, for: .normal)
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return imageListCell
    }
}

extension ImageListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchToSingleViewController(sender: indexPath)
    }
}

extension ImageListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImageListViewController {
    func updateTableViewAnimated() {
        UIBlockingProgressHUD.dismiss()
        let oldCount = self.photos.count
        let newCount = imagesListService.photos.count
        self.photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImageListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = self.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoID: photo.id, isLiked: photo.isLiked) { [weak self] result in
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
                    self.photos[indexPath.row] = newPhoto
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self.showAlert(error)
                }
            }
        }
    }
}
