//
//  SampleCollectionViewCell.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/19.
//

import UIKit
import AceLayout

final class SampleCollectionViewCell: UICollectionViewCell {
    
    private let thumbnailView: UIView = {
        let view = UIView()
        view.preservesSuperviewLayoutMargins = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    private func setUpViews() {
        preservesSuperviewLayoutMargins = true
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        // Subviews
        let labelArea = UIView()
        labelArea.preservesSuperviewLayoutMargins = true
        labelArea.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return .black.withAlphaComponent(0.6)
            case .dark:
                return .black.withAlphaComponent(0.3)
            @unknown default:
                return .black.withAlphaComponent(0.6)
            }
        }
        labelArea.addSubview(titleLabel)
        
        let stackView = UIStackView(arrangedSubviews: [thumbnailView, labelArea])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        contentView.addSubview(stackView)
        
        // Layout
        thumbnailView.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        stackView.autoLayout { item in
            item.edges.equalToSuperview()
        }
        
        thumbnailView.autoLayout { item in
            item.height.equal(to: 100)
        }
        
        titleLabel.autoLayout { item in
            item.leading.equal(to: labelArea.layoutMarginsGuide)
            item.trailing.lessThanOrEqual(to: labelArea.layoutMarginsGuide)
            item.topBottom.equal(to: labelArea, insetBy: 12)
        }
    }
    
    // MARK: - Methods
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
