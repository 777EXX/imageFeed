//
//  ImageListView.swift
//  ImageFeed
//
//  Created by Alexey on 29.04.2023.
//

import UIKit

final class ImageListView {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12,
                                              left: 0,
                                              bottom: 12,
                                              right: 0)
        return tableView
    }()
    
    func setTableViewDelegateAndDataSource(_ viewController: UIViewController) {
        tableView.delegate = viewController as? UITableViewDelegate
        tableView.dataSource = viewController as? UITableViewDataSource
    }
}
