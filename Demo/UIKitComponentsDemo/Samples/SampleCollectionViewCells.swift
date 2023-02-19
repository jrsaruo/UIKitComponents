//
//  SampleCollectionViewCell.swift
//  UIKitComponentsDemo
//
//  Created by Yusaku Nishi on 2023/02/19.
//

import UIKit
import AceLayout
import UIKitComponents

// MARK: - SampleCollectionViewCell -

class SampleCollectionViewCell: UICollectionViewCell {
    
    private let thumbnailView: UIView = {
        let view = UIView()
        view.preservesSuperviewLayoutMargins = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = .monospacedSystemFont(ofSize: 15, weight: .semibold)
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
    
    func setUpViews() {
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
            item.topBottom.equal(to: labelArea, insetBy: 10)
        }
    }
    
    // MARK: - Methods
    
    fileprivate func configure(title: String) {
        titleLabel.text = title
    }
    
    fileprivate func addThumbnail(_ thumbnail: UIView) {
        thumbnail.isUserInteractionEnabled = false
        thumbnailView.addSubview(thumbnail)
        thumbnail.autoLayout { item in
            item.edges.equal(to: thumbnailView.layoutMarginsGuide)
        }
    }
}

// MARK: - TextViewWithPlaceholderSampleCell -

final class TextViewWithPlaceholderSampleCell: SampleCollectionViewCell {
    
    override func setUpViews() {
        super.setUpViews()
        
        // Subviews
        let textView = TextViewWithPlaceholder()
        textView.backgroundColor = .systemGray6
        textView.placeholder = "Placeholder"
        textView.font = .systemFont(ofSize: 15)
        textView.textContainerInset.left = 3
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 8
        textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textView.layer.masksToBounds = true
        addThumbnail(textView)
        
        let caret = UIView()
        caret.backgroundColor = UIColor.tintColor
        textView.addSubview(caret)
        
        // Layout
        caret.autoLayout { item in
            item.top.equal(to: textView.layoutMarginsGuide)
            item.trailing.equal(to: textView.layoutMarginsGuide.leadingAnchor)
            item.width.equal(to: 2)
            item.height.equal(to: 18)
        }
        
        // Configuration
        configure(title: "TextViewWithPlaceholder")
    }
}
