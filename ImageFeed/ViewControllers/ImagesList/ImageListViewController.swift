import UIKit
import SnapKit

final class ImageListViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12,
                                              left: 0,
                                              bottom: 12,
                                              right: 0)
        
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setTableView()
    }
    
    private func switchToSingleViewController(sender: Any?) {
        let viewController = SingleImageViewController()
        viewController.modalPresentationStyle = .overFullScreen
        
        guard let indexPath = sender as? IndexPath else {return }
        
        let image = UIImage(named: photosName[indexPath.row])
        viewController.image = image
        
        present(viewController, animated: true)
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photoIndex = photosName[indexPath.row]
        let image = UIImage(named: String(photoIndex))
        
        guard let photo = image else { return }
        cell.cellImage.image = photo
        cell.cellLabel.text = Date().currentDate
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageListCell = ImagesListCell()
        
        configCell(for: imageListCell, with: indexPath)
    
        return imageListCell
    }
}

extension ImageListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchToSingleViewController(sender: indexPath)
    }
}
    
    
