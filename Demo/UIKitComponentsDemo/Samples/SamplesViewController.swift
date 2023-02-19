//
//  SamplesViewController.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/16.
//

import UIKit
import SwiftyTable

final class SamplesViewController: UIViewController {
    
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
        collectionView.register(TextViewWithPlaceholderSampleCell.self)
        return collectionView
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, Sample>(collectionView: collectionView) { collectionView, indexPath, sample in
        switch sample {
        case .textViewWithPlaceholder:
            return collectionView.dequeueReusableCell(of: TextViewWithPlaceholderSampleCell.self, for: indexPath)
        }
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

extension SamplesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sample = dataSource.itemIdentifier(for: indexPath)!
        navigationController?.pushViewController(sample.destination, animated: true)
    }
}

extension SamplesViewController {
    
    enum Sample: Int, CollectionItem, CaseIterable {
        case textViewWithPlaceholder
        
        var destination: UIViewController {
            switch self {
            case .textViewWithPlaceholder:
                return TextViewWithPlaceholderSampleViewController()
            }
        }
    }
}
