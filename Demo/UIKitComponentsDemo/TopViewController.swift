//
//  TopViewController.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/16.
//

import UIKit
import SwiftyTable

final class TopViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let columnCount = Int(layoutEnvironment.container.contentSize.width / 160)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(140)
                ),
                repeatingSubitem: .init(layoutSize: .init(
                    widthDimension: .fractionalWidth(1 / CGFloat(columnCount)),
                    heightDimension: .estimated(140)
                )),
                count: columnCount
            )
            group.interItemSpacing = .fixed(16)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsetsReference = .layoutMargins
            section.interGroupSpacing = 16
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.contentInset.top = 16
        collectionView.register(SampleCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, Sample>(collectionView: collectionView) { collectionView, indexPath, sample in
        let cell = collectionView.dequeueReusableCell(of: SampleCollectionViewCell.self, for: indexPath)
        cell.configure(title: sample.title)
        return cell
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        collectionView.delegate = self
        view = collectionView
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
        collectionView.deselectSelectedItems(with: transitionCoordinator, animated: animated)
    }
}

// MARK: - UICollectionViewDelegate -

extension TopViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sample = dataSource.itemIdentifier(for: indexPath)!
        navigationController?.pushViewController(sample.destination, animated: true)
    }
}

extension TopViewController {
    
    enum Sample: Int, CollectionItem, CaseIterable {
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
