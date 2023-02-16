//
//  TopViewController.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/16.
//

import UIKit
import SwiftyTable

final class TopViewController: UIViewController {
    
    enum Sample: Int, TableRow, CaseIterable {
        case sample
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self)
        return tableView
    }()
    
    private lazy var dataSource = UITableViewDiffableDataSource<Int, Sample>(tableView: tableView) { tableView, indexPath, sample in
        let cell = tableView.dequeueReusableCell(of: UITableViewCell.self, for: indexPath)
        return cell
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "UIKitComponents Demo"
        setUpViews()
    }
    
    private func setUpViews() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Sample.allCases)
        dataSource.apply(snapshot)
    }
}
