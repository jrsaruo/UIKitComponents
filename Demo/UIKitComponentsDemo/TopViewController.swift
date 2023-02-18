//
//  TopViewController.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/16.
//

import UIKit
import SwiftyTable

final class TopViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self)
        return tableView
    }()
    
    private lazy var dataSource = UITableViewDiffableDataSource<Int, Sample>(tableView: tableView) { tableView, indexPath, sample in
        let cell = tableView.dequeueReusableCell(of: UITableViewCell.self, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        var configuration = cell.defaultContentConfiguration()
        configuration.text = sample.title
        cell.contentConfiguration = configuration
        return cell
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        tableView.delegate = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectSelectedRow(with: transitionCoordinator, animated: animated)
    }
}

// MARK: - UITableViewDelegate -

extension TopViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = dataSource.itemIdentifier(for: indexPath)!
        navigationController?.pushViewController(sample.destination, animated: true)
    }
}

extension TopViewController {
    
    enum Sample: Int, TableRow, CaseIterable {
        case textViewWithPlaceholder
        
        var title: String {
            switch self {
            case .textViewWithPlaceholder:
                return "TextViewWithPlaceholder"
            }
        }
        
        var destination: UIViewController {
            switch self {
            case .textViewWithPlaceholder:
                return TextViewWithPlaceholderSampleViewController()
            }
        }
    }
}
